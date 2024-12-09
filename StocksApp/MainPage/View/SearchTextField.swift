//
//  searchTextField.swift
//  StocksApp
//
//  Created by Dias Kaussov on 30.11.2024.
//

import UIKit

protocol SearchTextFieldDelegate {
    func textFieldDidChanged(textField: UITextField)
    func textFieldDidEndEditing(textField: UITextField)
}

class SearchTextField: UITextField {
    private let padding = UIEdgeInsets(top: 0, left: 45, bottom: 0, right: 0)
    private let leftViewContainer = UIView()
    
    var searchTextFielDelegate: SearchTextFieldDelegate?
    
    init(placeholder: String, button: UIButton, toolbar: UIToolbar) {
        super.init(frame: .zero)
        setupLayout(placeholder: placeholder, button: button, toolbar: toolbar)
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
    
    private func setupLayout(placeholder: String, button: UIButton, toolbar: UIToolbar) {
        
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
        self.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        self.inputAccessoryView = toolbar
        
        self.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEnd)
        
        setLeftView()
        setupButton(button: button)
    }
    
    private func setLeftView() {
        leftViewContainer.translatesAutoresizingMaskIntoConstraints = false
        leftViewContainer.isUserInteractionEnabled = true
        self.leftViewMode = UITextField.ViewMode.always
        self.leftView = leftViewContainer
    }
    
    private func setupButton(button: UIButton) {
        self.addSubview(leftViewContainer)
        leftViewContainer.addSubview(button)
        
        NSLayoutConstraint.activate([
            leftViewContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            leftViewContainer.topAnchor.constraint(equalTo: self.topAnchor),
            leftViewContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            leftViewContainer.widthAnchor.constraint(equalToConstant: 40),
            
            button.leadingAnchor.constraint(equalTo: leftViewContainer.leadingAnchor, constant: 15),
            button.centerYAnchor.constraint(equalTo: leftViewContainer.centerYAnchor),
        ])
    }
    
    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        print("delegate")
        searchTextFielDelegate?.textFieldDidChanged(textField: self)
    }
    @objc
    private func textFieldDidEndEditing(_ textField: UITextField) {
        searchTextFielDelegate?.textFieldDidEndEditing(textField: self)
    }
}
