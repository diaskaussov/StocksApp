//
//  PopularRequestsLabel.swift
//  StocksApp
//
//  Created by Dias Kaussov on 28.01.2025.
//

import UIKit

final class PopularRequestsLabel: UILabel {
    init(content: String) {
        super.init(frame: .zero)
        setupLabelProperties(content: content)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLabelProperties(content: String) {
        text = content
        textColor = .black
        font = .systemFont(ofSize: 24, weight: .bold)
        translatesAutoresizingMaskIntoConstraints = false
    }
}
