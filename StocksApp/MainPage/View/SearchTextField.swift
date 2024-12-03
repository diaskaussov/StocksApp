//
//  searchTextField.swift
//  StocksApp
//
//  Created by Dias Kaussov on 30.11.2024.
//

import UIKit

class SearchTextField: UITextField {
    private let padding = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 0)
    private let leftViewContainer = UIView()
    
    init(placeholder: String, button: UIButton) {
        super.init(frame: .zero)
        setupLayout(placeholder: placeholder, button: button)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = true
        leftViewContainer.isUserInteractionEnabled = true
        button.isUserInteractionEnabled = true
        
        leftViewContainer.backgroundColor = .lightGray
        button.backgroundColor = .blue
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    private func setupLayout(placeholder: String, button: UIButton) {
        textColor = .black
        layer.cornerRadius = 24
        layer.borderWidth = 1
        layer.borderColor = CGColor(
            red: 0,
            green: 0,
            blue: 0,
            alpha: 1
        )
        self.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        setupButton(button: button)
    }
    
    private func setupButton(button: UIButton) {
        self.addSubview(leftViewContainer)
        leftViewContainer.translatesAutoresizingMaskIntoConstraints = false
        leftViewContainer.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        self.leftViewMode = UITextField.ViewMode.always
        self.leftView = leftViewContainer
        NSLayoutConstraint.activate([
            
            leftViewContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            leftViewContainer.topAnchor.constraint(equalTo: self.topAnchor),
            leftViewContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            leftViewContainer.widthAnchor.constraint(equalToConstant: 40),
            
            button.leadingAnchor.constraint(equalTo: leftViewContainer.leadingAnchor, constant: 10),
            button.centerYAnchor.constraint(equalTo: leftViewContainer.centerYAnchor),
        ])
    }
}
