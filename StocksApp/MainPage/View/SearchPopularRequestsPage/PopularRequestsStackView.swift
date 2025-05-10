//
//  PopularRequestsStackView.swift
//  StocksApp
//
//  Created by Dias Kaussov on 28.01.2025.
//

import UIKit

final class PopularRequestsStackView: UIStackView {
    init() {
        super.init(frame: .zero)
        setupStackProperties()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStackProperties() {
        axis = .horizontal
        spacing = 10
        translatesAutoresizingMaskIntoConstraints = false
    }
}
