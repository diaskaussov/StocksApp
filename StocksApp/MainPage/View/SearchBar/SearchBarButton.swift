//
//  SearchBarButton.swift
//  StocksApp
//
//  Created by Dias Kaussov on 28.01.2025.
//

import UIKit

final class SearchBarButton: UIButton {
    init(image: String) {
        super.init(frame: .zero)
        setupButtonProperties(text: image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButtonProperties(text: String) {
        setImage(
            UIImage(
                systemName: text,
                withConfiguration: UIImage.SymbolConfiguration(
                    font: .systemFont(ofSize: 20.0, weight: .semibold)
                )
            ),
            for: .normal
        )
        tintColor = .black
        translatesAutoresizingMaskIntoConstraints = false
    }
}
