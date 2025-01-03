//
//  SearchPopularRequestsButton.swift
//  StocksApp
//
//  Created by Dias Kaussov on 31.12.2024.
//

import UIKit

final class PopularRequestsButton: UIButton {
    init(text: String) {
        super.init(frame: .zero)
        setButtonProperties(title: text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setButtonProperties(title: String) {
        setTitle(title, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 14)
        setTitleColor(.black, for: .normal)
        backgroundColor = .systemGray6
        layer.cornerRadius = 16
    }
}
