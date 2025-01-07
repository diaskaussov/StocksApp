//
//  ChartButton.swift
//  StocksApp
//
//  Created by Dias Kaussov on 27.12.2024.
//

import UIKit

final class MenuButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        setProperties(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties(title: String) {
        titleLabel?.font = .systemFont(ofSize: 18)
        setTitle(title, for: .normal)
        setTitleColor(.black, for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
    }
}
