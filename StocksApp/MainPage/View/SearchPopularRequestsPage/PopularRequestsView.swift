//
//  SearchPopularRequestsScrollView.swift
//  StocksApp
//
//  Created by Dias Kaussov on 01.01.2025.
//

import UIKit

protocol PopularRequestsViewDelegate {
    func textReceived(text: String)
}

final class PopularRequestsView: UIView {
    var popularRequestsViewDelegate: PopularRequestsViewDelegate?
    
    private var stocks: [StockModel]
    
    private let scroll1PopularRequests = PopularRequestsScrollView()
    
    private let scroll2PopularRequests = PopularRequestsScrollView()
    
    private let stack1PopularRequests = PopularRequestsStackView()
    
    private let stack2PopularRequests = PopularRequestsStackView()
    
    init(stocks: [StockModel]) {
        self.stocks = stocks
        super.init(frame: .zero)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Setup View Layout

extension PopularRequestsView {
    private func addSubviews() {
        addSubview(scroll1PopularRequests)
        addSubview(scroll2PopularRequests)
        scroll1PopularRequests.addSubview(stack1PopularRequests)
        scroll2PopularRequests.addSubview(stack2PopularRequests)
//        for model in 0..<20 {
//            let button1 = PopularRequestsButton(text: stocks[model].jsonModel.name)
//            button1.popularRequestsButtonDelegate = self
//            stack1PopularRequests.addArrangedSubview(button1)
//
//            let button2 = PopularRequestsButton(text: stocks[model].jsonModel.name)
//            button2.popularRequestsButtonDelegate = self
//            stack2PopularRequests.addArrangedSubview(button2)
//        }
    }
    
    private func setupConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scroll1PopularRequests.topAnchor.constraint(equalTo: self.topAnchor),
            scroll1PopularRequests.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scroll1PopularRequests.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scroll1PopularRequests.heightAnchor.constraint(equalToConstant: 40),
            
            stack1PopularRequests.topAnchor.constraint(
                equalTo: scroll1PopularRequests.contentLayoutGuide.topAnchor
            ),
            stack1PopularRequests.leadingAnchor.constraint(
                equalTo: scroll1PopularRequests.contentLayoutGuide.leadingAnchor
            ),
            stack1PopularRequests.trailingAnchor.constraint(
                equalTo: scroll1PopularRequests.contentLayoutGuide.trailingAnchor
            ),
            stack1PopularRequests.bottomAnchor.constraint(
                equalTo: scroll1PopularRequests.contentLayoutGuide.bottomAnchor
            ),
            
            scroll2PopularRequests.topAnchor.constraint(equalTo: scroll1PopularRequests.bottomAnchor, constant: 10),
            scroll2PopularRequests.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scroll2PopularRequests.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scroll2PopularRequests.heightAnchor.constraint(equalToConstant: 40),
            
            stack2PopularRequests.topAnchor.constraint(
                equalTo: scroll2PopularRequests.contentLayoutGuide.topAnchor
            ),
            stack2PopularRequests.leadingAnchor.constraint(
                equalTo: scroll2PopularRequests.contentLayoutGuide.leadingAnchor
            ),
            stack2PopularRequests.trailingAnchor.constraint(
                equalTo: scroll2PopularRequests.contentLayoutGuide.trailingAnchor
            ),
            stack2PopularRequests.bottomAnchor.constraint(
                equalTo: scroll2PopularRequests.contentLayoutGuide.bottomAnchor
            )
        ])
    }
}

//MARK: - PopularRequestsButtonDelegate

extension PopularRequestsView: PopularRequestsButtonDelegate {
    func searchPopularRequests(text: String) {
        popularRequestsViewDelegate?.textReceived(text: text)
    }
}
