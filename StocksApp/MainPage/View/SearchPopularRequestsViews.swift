//
//  SearchPopularRequestsViews.swift
//  StocksApp
//
//  Created by Dias Kaussov on 29.12.2024.
//

import UIKit

class SearchPopularRequestsLabel: UILabel {
    init(text: String) {
        super.init(frame: .zero)
        setParameters(text: text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setParameters(text: String) {
        self.text = text
        font = .systemFont(ofSize: 24, weight: .bold)
        translatesAutoresizingMaskIntoConstraints = false
    }
}

//class SearchPopularRequestsCollectionView: UICollectionView {
//    init() {
//        super.init(frame: .zero)
//        translatesAutoresizingMaskIntoConstraints = false
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
