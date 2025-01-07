//
//  TopView.swift
//  StocksApp
//
//  Created by Dias Kaussov on 30.12.2024.
//

import UIKit

final class TopView: UIView {
    init() {
        super.init(frame: .zero)
        addSubviews()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var starButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.setImage(UIImage(systemName: "star.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.setImage(UIImage(systemName: "arrowshape.backward"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let stockTicker: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let stockName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func addSubviews() {
        addSubview(backButton)
        addSubview(stockTicker)
        addSubview(stockName)
        addSubview(starButton)
    }
    
    private func setLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            backButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            stockTicker.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -15),
            stockTicker.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            stockName.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 15),
            stockName.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            starButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            starButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
}
