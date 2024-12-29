//
//  ChartButton.swift
//  StocksApp
//
//  Created by Dias Kaussov on 30.12.2024.
//

import UIKit

class ChartButton: UIButton {
    init(name: String) {
        super.init(frame: .zero)
        setProperties(name: name)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties(name: String) {
        setTitle(name, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 16)
        backgroundColor = .systemGray6
        setTitleColor(.black, for: .normal)
        layer.cornerRadius = 16
    }
}
