//
//  searchTextField.swift
//  StocksApp
//
//  Created by Dias Kaussov on 30.11.2024.
//

import UIKit

protocol SearchTextFieldDelegate {
    func textFieldDidBeginEditing(textField: UITextField)
    func textFieldDidChanged(textField: UITextField)
    func textFieldDidEndEditing(textField: UITextField)
    func textFieldShouldReturn(textField: UITextField)
}

final class SearchTextField: UITextField {
    private let padding = UIEdgeInsets(top: 0, left: 45, bottom: 0, right: 0)
    private let leftViewContainer = UIView()
    private let rightViewContainer = UIView()
    
    var searchTextFielDelegate: SearchTextFieldDelegate?
    
    init(placeholder: String, leftButton: UIButton, rightButton: UIButton) {
        super.init(frame: .zero)
        setupLayout(
            placeholder: placeholder,
            leftButton: leftButton,
            rightButton: rightButton
        )
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
    
    private func setupLayout(
        placeholder: String,
        leftButton: UIButton,
        rightButton: UIButton
    ) {
        textColor = .black
        layer.cornerRadius = 24
        layer.borderWidth = 1
        returnKeyType = .done
        layer.borderColor = CGColor(
            red: 0,
            green: 0,
            blue: 0,
            alpha: 1
        )
        
        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        
        translatesAutoresizingMaskIntoConstraints = false
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        
        addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: .editingDidBegin)
        addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEnd)
        addTarget(self, action: #selector(textFieldShouldReturn(_:)), for: .primaryActionTriggered)
        
        setViews()
        setupButton(leftButton: leftButton, rightButton: rightButton)
    }
    
    private func setViews() {
        leftViewContainer.translatesAutoresizingMaskIntoConstraints = false
        leftViewContainer.isUserInteractionEnabled = true
        leftViewMode = UITextField.ViewMode.always
        leftView = leftViewContainer
        
        rightViewContainer.translatesAutoresizingMaskIntoConstraints = false
        rightViewContainer.isUserInteractionEnabled = true
        rightViewMode = UITextField.ViewMode.always
        rightView = rightViewContainer
    }
    
    private func setupButton(leftButton: UIButton, rightButton: UIButton) {
        addSubview(leftViewContainer)
        addSubview(rightViewContainer)
        leftViewContainer.addSubview(leftButton)
        rightViewContainer.addSubview(rightButton)
        
        NSLayoutConstraint.activate([
            leftViewContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            leftViewContainer.topAnchor.constraint(equalTo: self.topAnchor),
            leftViewContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            leftViewContainer.widthAnchor.constraint(equalToConstant: 40),
            
            leftButton.leadingAnchor.constraint(equalTo: leftViewContainer.leadingAnchor, constant: 15),
            leftButton.centerYAnchor.constraint(equalTo: leftViewContainer.centerYAnchor),
            
            rightViewContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            rightViewContainer.topAnchor.constraint(equalTo: self.topAnchor),
            rightViewContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            rightViewContainer.widthAnchor.constraint(equalToConstant: 40),
            
            rightButton.trailingAnchor.constraint(equalTo: rightViewContainer.trailingAnchor, constant: -15),
            rightButton.centerYAnchor.constraint(equalTo: rightViewContainer.centerYAnchor),
        ])
    }
    
    @objc
    private func textFieldDidBeginEditing(_ textField: UITextField) {
        searchTextFielDelegate?.textFieldDidBeginEditing(textField: self)
    }
    
    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        searchTextFielDelegate?.textFieldDidChanged(textField: self)
    }
    @objc
    private func textFieldDidEndEditing(_ textField: UITextField) {
        searchTextFielDelegate?.textFieldDidEndEditing(textField: self)
    }
    @objc
    private func textFieldShouldReturn(_ textField: UITextField) {
        searchTextFielDelegate?.textFieldShouldReturn(textField: self)
    }
}
