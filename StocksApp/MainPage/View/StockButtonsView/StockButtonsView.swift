//
//  TextFieldButtonsView.swift
//  StocksApp
//
//  Created by Dias Kaussov on 21.01.2025.
//

import UIKit

protocol StockButtonsViewDelegate {
    func buttonTapped()
}

class StockButtonsView: UIView {
    var stockButtonsViewDelegate: StockButtonsViewDelegate?
    
    lazy var stocksButton: UIButton = {
        let button = UIButton()
        button.setTitle("Stocks", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 36, weight: .bold)
        button.isSelected = true
        button.addTarget(self, action: #selector(buttonSelected), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var favouriteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Favourite", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .semibold)
        button.contentHorizontalAlignment = .left
        button.isSelected = false
        button.addTarget(self, action: #selector(buttonSelected), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func buttonSelected(_ sender: UIButton) {
        guard let title = sender.titleLabel?.text else { return }
        
        makeFontSelected(sender)
        
        if title == "Stocks" {
            makeFontDefault(favouriteButton)
            stocksButton.isSelected = true
            favouriteButton.isSelected = false
        } else {
            makeFontDefault(stocksButton)
            stocksButton.isSelected = false
            favouriteButton.isSelected = true
        }
        stockButtonsViewDelegate?.buttonTapped()
    }
    
    private func makeFontDefault(_ sender: UIButton) {
        sender.titleLabel?.font = .systemFont(
            ofSize: 24,
            weight: .semibold
        )
        sender.setTitleColor(.gray, for: .normal)
    }

    private func makeFontSelected(_ sender: UIButton) {
        sender.titleLabel?.font = .systemFont(
            ofSize: 36,
            weight: .bold
        )
        sender.setTitleColor(.black, for: .normal)
    }
}

extension StockButtonsView {
    private func setUI() {
        addSubview(stocksButton)
        addSubview(favouriteButton)
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stocksButton.topAnchor.constraint(equalTo: self.topAnchor),
            stocksButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            stocksButton.heightAnchor.constraint(equalToConstant: 90),
            stocksButton.widthAnchor.constraint(equalToConstant: 150),
            
            favouriteButton.topAnchor.constraint(equalTo: self.topAnchor),
            favouriteButton.leadingAnchor.constraint(equalTo: stocksButton.trailingAnchor),
            favouriteButton.heightAnchor.constraint(equalToConstant: 90),
            favouriteButton.widthAnchor.constraint(equalToConstant: 200),
        ])
    }
}
