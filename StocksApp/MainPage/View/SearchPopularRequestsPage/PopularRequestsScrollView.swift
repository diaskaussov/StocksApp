//
//  PopularRequestsScrollView.swift
//  StocksApp
//
//  Created by Dias Kaussov on 28.01.2025.
//

import UIKit

final class PopularRequestsScrollView: UIScrollView {
    init() {
        super.init(frame: .zero)
        setupScrollProperties()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupScrollProperties() {
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        translatesAutoresizingMaskIntoConstraints = false
        bounces = false
    }
}
