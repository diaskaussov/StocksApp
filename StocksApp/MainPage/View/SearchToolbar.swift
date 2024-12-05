//
//  Untitled.swift
//  StocksApp
//
//  Created by Dias Kaussov on 05.12.2024.
//

import UIKit

protocol SearchToolbarDelegate {
    func phonePressed()
}

class SearchToolbar: UIToolbar {
    
    let vc = MainViewController()
    
    var toolbarDelegate: SearchToolbarDelegate?
    
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        barStyle = .default
        isTranslucent = false
        tintColor = .blue
        sizeToFit()
        
        let spaceArea: UIBarButtonItem = .init(systemItem: .flexibleSpace)
        let doneButton: UIBarButtonItem = .init(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(phonePressed)
        )
        
        setItems([spaceArea, doneButton], animated: false)
        isUserInteractionEnabled = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc
    private func phonePressed() {
        toolbarDelegate?.phonePressed()
    }
   
}
