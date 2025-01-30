//
//  SearchPopularRequestsViews.swift
//  StocksApp
//
//  Created by Dias Kaussov on 29.12.2024.
//

import UIKit

protocol SearchPopularRequestsPageDelegate {
    func searchForTheCompanyByTitle(title: String)
}

final class SearchPopularRequestsPage: UIView {
    var searchPopularRequestsPageDelegate: SearchPopularRequestsPageDelegate?
    
    private var stocks: [StockModel]
    
    private lazy var popularRequestsView = PopularRequestsView(stocks: stocks)
    
    private lazy var searchedItemsView = PopularRequestsView(stocks: stocks)
    
    private let popularRequestsLabel = PopularRequestsLabel(content: "Popular requests")
    
    private let searchedItemsLabel = PopularRequestsLabel(content: "You've searched for this")
    
    init(stocks: [StockModel]) {
        self.stocks = stocks
        super.init(frame: .zero)
        addSubviews()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Setup View Layout

extension SearchPopularRequestsPage {
    private func addSubviews() {
        addSubview(popularRequestsLabel)
        addSubview(popularRequestsView)
        addSubview(searchedItemsLabel)
        addSubview(searchedItemsView)
        popularRequestsView.popularRequestsViewDelegate = self
        searchedItemsView.popularRequestsViewDelegate = self
    }
    
    private func setLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popularRequestsLabel.topAnchor.constraint(equalTo: self.topAnchor),
            popularRequestsLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            popularRequestsLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            popularRequestsLabel.heightAnchor.constraint(equalToConstant: 30),
            
            popularRequestsView.topAnchor.constraint(equalTo: popularRequestsLabel.bottomAnchor, constant: 10),
            popularRequestsView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            popularRequestsView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            popularRequestsView.heightAnchor.constraint(equalToConstant: 90),
            
            searchedItemsLabel.topAnchor.constraint(equalTo: popularRequestsView.bottomAnchor, constant: 40),
            searchedItemsLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            searchedItemsLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            searchedItemsLabel.heightAnchor.constraint(equalToConstant: 30),
            
            searchedItemsView.topAnchor.constraint(equalTo: searchedItemsLabel.bottomAnchor, constant: 10),
            searchedItemsView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            searchedItemsView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            searchedItemsView.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
}

//MARK: - PopularRequestsViewDelegate

extension SearchPopularRequestsPage: PopularRequestsViewDelegate {
    func textReceived(text: String) {
        searchPopularRequestsPageDelegate?.searchForTheCompanyByTitle(title: text)
    }
}
