//
//  CoreDataHelper.swift
//  MoviesListApp
//
//  Created by MA1424 on 25/01/24.
//

import UIKit
import CoreData



class CoreDataHelper {
    
    static let shared = CoreDataHelper(mainContext: CoreDataStack.shared.viewContext)

    let mainManagedObjectContext: NSManagedObjectContext
    let privateManagedObjectContext: NSManagedObjectContext

    init(mainContext: NSManagedObjectContext) {
        self.mainManagedObjectContext = mainContext
        self.privateManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        self.privateManagedObjectContext.parent = mainContext
    }

    private func saveMainContext() {
        if mainManagedObjectContext.hasChanges {
            do {
                try mainManagedObjectContext.save()
            } catch {
                // Consider a better error handling strategy here
                print("Error saving main managed object context: \(error)")
            }
        }
    }
    
    private func savePrivateContext() {
        if privateManagedObjectContext.hasChanges {
            do {
                try privateManagedObjectContext.save()
            } catch {
                // Consider a better error handling strategy here
                print("Error saving private managed object context: \(error)")
            }
        }
    }

    func saveChanges() {
        savePrivateContext()
        mainManagedObjectContext.performAndWait {
            saveMainContext()
        }
    }

    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        privateManagedObjectContext.perform {
            block(self.privateManagedObjectContext)
        }
    }

    // Other methods...
    func saveData<T: NSManagedObject>(objects: [T]) {
        privateManagedObjectContext.perform {
            // Insert the objects into the private context
            for object in objects {
                self.privateManagedObjectContext.insert(object)
            }
            
            // Save changes to the private context and merge to the main context
            self.saveChanges()
        }
    }
    
    func updateData<T: NSManagedObject>(objects: [T]) {
        privateManagedObjectContext.perform {
            // Update the objects in the private context
            for object in objects {
                if object.managedObjectContext == self.privateManagedObjectContext {
                    // If the object is already in the private context, update it directly
                    object.managedObjectContext?.refresh(object, mergeChanges: true)
                } else {
                    // If the object is not in the private context, fetch and update it
                    let fetchRequest = NSFetchRequest<T>(entityName: object.entity.name!)
                    fetchRequest.predicate = NSPredicate(format: "SELF == %@", object)
                    fetchRequest.fetchLimit = 1
                    
                    if let fetchedObject = try? self.privateManagedObjectContext.fetch(fetchRequest).first {
                        fetchedObject.setValuesForKeys(object.dictionaryWithValues(forKeys: Array(object.entity.attributesByName.keys)))
                    }
                }
            }
            
            
            
            // Save changes to the private context and merge to the main context
            self.saveChanges()
        }
    }
    
    func deleteData<T: NSManagedObject>(objects: [T]) {
        privateManagedObjectContext.perform {
            // Delete the objects from the private context
            for object in objects {
                if object.managedObjectContext == self.privateManagedObjectContext {
                    self.privateManagedObjectContext.delete(object)
                } else {
                    if let objectInContext = self.privateManagedObjectContext.object(with: object.objectID) as? T {
                        self.privateManagedObjectContext.delete(objectInContext)
                    }
                }
            }
            
            // Save changes to the private context and merge to the main context
            self.saveChanges()
        }
    }
}


// How to use this helper  **********

//import UIKit
//import CoreData
//
//class ViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Save data to Core Data
//        savePersonData()
//
//        // Retrieve all person data and use the result
//        let allPeople = retrieveAllPeople()
//        for person in allPeople {
//            print("Name: \(person.name ?? ""), Age: \(person.age)")
//        }
//
//        // Retrieve specific person data by name and use the result
//        let personName = "John Doe"
//        let specificPerson = retrievePerson(byName: personName)
//        if let specificPerson = specificPerson {
//            print("Specific Person - Name: \(specificPerson.name ?? ""), Age: \(specificPerson.age)")
//
//            // Update specific person data and save changes
//            updatePersonData(byName: personName, newAge: 35)
//        } else {
//            print("Person with name '\(personName)' not found.")
//        }
//
//        // Delete specific person data and save changes
//        deletePersonData(byName: personName)
//
//        // Retrieve all person data again after deletion and use the result
//        let remainingPeople = retrieveAllPeople()
//        for person in remainingPeople {
//            print("Name: \(person.name ?? ""), Age: \(person.age)")
//        }
//    }
//
//    func savePersonData() {
//        let newPerson = NSEntityDescription.insertNewObject(forEntityName: "Person", into: CoreDataHelper.shared.privateManagedObjectContext) as! Person
//        newPerson.name = "John Doe"
//        newPerson.age = 30
//        CoreDataHelper.shared.saveData(objects: [newPerson])
//    }
//
//    func retrieveAllPeople() -> [Person] {
//        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
//
//        var people = [Person]()
//        CoreDataHelper.shared.mainManagedObjectContext.performAndWait {
//            do {
//                people = try CoreDataHelper.shared.mainManagedObjectContext.fetch(fetchRequest)
//            } catch {
//                print("Error fetching data: \(error)")
//            }
//        }
//        return people
//    }
//
//    func retrievePerson(byName name: String) -> Person? {
//        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
//        fetchRequest.fetchLimit = 1
//
//        var people = [Person]()
//        CoreDataHelper.shared.mainManagedObjectContext.performAndWait {
//            do {
//                people = try CoreDataHelper.shared.mainManagedObjectContext.fetch(fetchRequest)
//            } catch {
//                print("Error fetching specific person data: \(error)")
//            }
//        }
//        return people.first
//    }
//
//    func updatePersonData(byName name: String, newAge: Int) {
//        if let person = retrievePerson(byName: name) {
//            person.age = Int32(newAge)
//            CoreDataHelper.shared.updateData(objects: [person])
//        } else {
//            print("Person with name '\(name)' not found.")
//        }
//    }
//
//    func deletePersonData(byName name: String) {
//        if let person = retrievePerson(byName: name) {
//            CoreDataHelper.shared.deleteData(objects: [person])
//            print("Person with name '\(name)' deleted.")
//        } else {
//            print("Person with name '\(name)' not found for deletion.")
//        }
//    }
//}
