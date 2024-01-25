//
//  CustomSegmentedControl.swift
//  MarvelCharacters
//
//  Created by Apple on 13/07/22.
//

import UIKit

protocol CustomSegmentedControlDelegate: AnyObject {
    func change(to index: Int)
}

class CustomSegmentedControl: UIView {
    
    private var buttonTitles: [String]! {
        didSet {
            updateView()
        }
    }
    private var buttons: [UIButton] = []
    private var selectorView: UIView!
    private var scrollView: UIScrollView!
    
    var textColor: UIColor = .label
    var selectorViewColor: UIColor = .label
    var selectorTextColor: UIColor = .red
    
    weak var delegate: CustomSegmentedControlDelegate?
    
    public private(set) var selectedIndex: Int = 0
    
    convenience init(frame: CGRect, buttonTitle: [String]) {
        self.init(frame: frame)
        self.buttonTitles = buttonTitle
        setupScrollView()
        setupSelectorView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutButtons()
        updateSelectorPosition()
    }
    
    func setButtonTitles(buttonTitles: [String]) {
        self.buttonTitles = buttonTitles
    }
    
    func setIndex(index: Int) {
        guard index < buttons.count else { return }
        
        buttons.forEach({ $0.setTitleColor(textColor, for: .normal) })
        let button = buttons[index]
        selectedIndex = index
        button.setTitleColor(selectorTextColor, for: .normal)
        
        UIView.animate(withDuration: 0.3) {
            self.selectorView.frame.origin.x = button.frame.origin.x
            self.selectorView.frame.size.width = button.frame.size.width
        }
    }
    
    @objc func buttonAction(sender: UIButton) {
        guard let index = buttons.firstIndex(of: sender) else { return }
        
        setIndex(index: index)
        delegate?.change(to: index)
    }
    
    private func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: self.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
    }
    
    private func setupSelectorView() {
        selectorView = UIView()
        selectorView.backgroundColor = selectorViewColor
        scrollView.addSubview(selectorView)
    }
    
    private func updateView() {
        createButtons()
        layoutButtons()
    }
    
    private func createButtons() {
        buttons.forEach { $0.removeFromSuperview() }
        buttons = buttonTitles.map { title -> UIButton in
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.setTitleColor(textColor, for: .normal)
            button.backgroundColor = UIColor.clear  // Default background color
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16) // Bold font
            button.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
            return button
        }
    }
    
    private func layoutButtons() {
        var currentX: CGFloat = 0
        let buttonHeight = self.frame.height
        
        buttons.forEach { button in
            button.sizeToFit() // Size button to fit its title
            let buttonWidth = button.frame.width + 20 // Padding for the button
            button.frame = CGRect(x: currentX, y: 0, width: buttonWidth, height: buttonHeight)
            scrollView.addSubview(button)
            currentX += buttonWidth
        }
        
        scrollView.contentSize = CGSize(width: currentX, height: buttonHeight)
        updateSelectorPosition()
    }
    
    private func updateSelectorPosition() {
        guard buttons.indices.contains(selectedIndex) else { return }
        
        let selectorWidth = buttons[selectedIndex].frame.width
        let selectorX = buttons[selectedIndex].frame.origin.x
        
        selectorView.frame = CGRect(x: selectorX, y: self.frame.height - 2.5, width: selectorWidth, height: 2.5)
    }
}
