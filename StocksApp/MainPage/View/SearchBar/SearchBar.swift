//
//  searchTextField.swift
//  StocksApp
//
//  Created by Dias Kaussov on 30.11.2024.
//

import UIKit

protocol SearchBarDelegate {
    func textFieldDidBeginEditing(textField: UITextField)
    
    func textFieldDidChanged(textField: UITextField)
    
    func textFieldDidEndEditing(textField: UITextField)
    
    func textFieldShouldReturn(textField: UITextField)
    
    func cancelButtonTapped()
}

final class SearchBar: UITextField {
    var searchBarDelegate: SearchBarDelegate?
    
    private let padding = UIEdgeInsets(top: 0, left: 45, bottom: 0, right: 45)
    
    private let leftViewContainer = UIView()
    
    private let rightViewContainer = UIView()
    
    private let searchButton = SearchBarButton(image: "magnifyingglass")
    
    private let cancelButton = SearchBarButton(image: "x.circle")
    
    init(placeholder: String) {
        super.init(frame: .zero)
        setupSearchBarProperties(placeholder: placeholder)
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
    
    @objc
    private func textFieldDidBeginEditing(_ textField: UITextField) {
        searchBarDelegate?.textFieldDidBeginEditing(textField: self)
    }
    
    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        searchBarDelegate?.textFieldDidChanged(textField: self)
    }
    @objc
    private func textFieldDidEndEditing(_ textField: UITextField) {
        searchBarDelegate?.textFieldDidEndEditing(textField: self)
    }
    @objc
    private func textFieldShouldReturn(_ textField: UITextField) {
        searchBarDelegate?.textFieldShouldReturn(textField: self)
    }
    
    @objc
    private func cancelText(_ sender: UIButton) {
        self.resignFirstResponder()
        self.text = ""
        searchBarDelegate?.cancelButtonTapped()
    }
    
    @objc
    private func startSearch(_ sender: UIButton) {
        self.becomeFirstResponder()
    }
}

//MARK: - Setup SearchBar Properties

extension SearchBar {
    private func setupSearchBarProperties(placeholder: String) {
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
        
        addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: .editingDidBegin)
        addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEnd)
        addTarget(self, action: #selector(textFieldShouldReturn(_:)), for: .primaryActionTriggered)
        
        searchButton.addTarget(self, action: #selector(startSearch), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelText), for: .touchUpInside)
        
        setViews()
        setupButton()
    }
}

//MARK: - Setup SearchBar Layout

extension SearchBar {
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
    
    private func setupButton() {
        addSubview(leftViewContainer)
        addSubview(rightViewContainer)
        leftViewContainer.addSubview(searchButton)
        rightViewContainer.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            leftViewContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            leftViewContainer.topAnchor.constraint(equalTo: self.topAnchor),
            leftViewContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            leftViewContainer.widthAnchor.constraint(equalToConstant: 40),
            
            searchButton.leadingAnchor.constraint(equalTo: leftViewContainer.leadingAnchor, constant: 15),
            searchButton.centerYAnchor.constraint(equalTo: leftViewContainer.centerYAnchor),
            
            rightViewContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            rightViewContainer.topAnchor.constraint(equalTo: self.topAnchor),
            rightViewContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            rightViewContainer.widthAnchor.constraint(equalToConstant: 40),
            
            cancelButton.trailingAnchor.constraint(equalTo: rightViewContainer.trailingAnchor, constant: -15),
            cancelButton.centerYAnchor.constraint(equalTo: rightViewContainer.centerYAnchor),
        ])
    }
}
