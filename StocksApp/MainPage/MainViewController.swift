//
//  ViewController.swift
//  StocksApp
//
//  Created by Dias Kaussov on 15.11.2024.
//

import UIKit
import CoreData

final class MainViewController: UIViewController {
    private var isSearching = false
    
    private let mainPageManager = MainPageManager()
    
    private let buttonView = StockButtonsView()
    
    private lazy var popularRequestsPage = SearchPopularRequestsPage(stocks: mainPageManager.stockModels)
    
    private lazy var searchBar = SearchBar(placeholder: "Find company or ticker")
    
    private let activityIndicator : UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let stocksTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            StocksTableViewCell.self,
            forCellReuseIdentifier: StocksTableViewCell.identifier
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    override func viewDidLoad() {
        print("View did load")
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stocksTableView.reloadData()
    }
}

//MARK: - MainViewController SetUp

private extension MainViewController {
    private func setupUI() {
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        addSubViews()
        setupLayout()
        setDelegates()
    }
}

private extension MainViewController {
    private func addSubViews() {
        view.addSubview(searchBar)
        view.addSubview(buttonView)
        view.addSubview(stocksTableView)
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        stocksTableView.isHidden = true
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            
            buttonView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            buttonView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonView.heightAnchor.constraint(equalToConstant: 90),
            
            stocksTableView.topAnchor.constraint(equalTo: buttonView.bottomAnchor),
            stocksTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stocksTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stocksTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setDelegates() {
        stocksTableView.delegate = self
        stocksTableView.dataSource = self
        buttonView.stockButtonsViewDelegate = self
        searchBar.searchBarDelegate = self
        mainPageManager.mainPageManagerDelegate = self
        popularRequestsPage.searchPopularRequestsPageDelegate = self
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if buttonView.favouriteButton.isSelected {
            return mainPageManager.getNumberOfFavouriteStocks()
        } else if isSearching {
            return mainPageManager.getNumberOfSearchingCells()
        }
        return mainPageManager.stockModels.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if buttonView.favouriteButton.isSelected {
            if indexPath.row + 1 >= mainPageManager.favouriteModels.count {
                let count = mainPageManager.favouriteModels.count + 1
                if mainPageManager.numberOfStocksCoreData >= 20 {
                    mainPageManager.stockMakeNetworkRequests(count, count + 19)
                    mainPageManager.numberOfStocksCoreData -= 20
                } else if mainPageManager.numberOfStocksCoreData > 0 {
                    mainPageManager.stockMakeNetworkRequests(count, count + mainPageManager.numberOfStocksCoreData - 1)
                    mainPageManager.numberOfStocksCoreData = 0
                }
            }
        } else {
            if indexPath.row + 1 >= mainPageManager.stockModels.count {
                let count = mainPageManager.stockModels.count + 1
                mainPageManager.stockMakeNetworkRequests(count, count + 19)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: StocksTableViewCell.identifier,
            for: indexPath
        ) as? StocksTableViewCell else { fatalError("Error dequeueing cell") }
        
        cell.delegate = self
        
        cell.setBackground(even: indexPath.row % 2 == 0)
        
        let stock = getStock(index: indexPath.row)
        
        cell.configure(cellModel: stock)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let stock = getStock(index: indexPath.row)
        let presenter = ChartsPresenter(stock: stock)
        let vc = ChartsViewController(presenter: presenter)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func getStock(index: Int) -> StockModel {
        if buttonView.favouriteButton.isSelected {
            return mainPageManager.favouriteModels[index]
        } else if mainPageManager.searchModels.isEmpty == false {
            return mainPageManager.searchModels[index]
        } else {
            return mainPageManager.getModel(index: index)
        }
    }
}

//MARK: - StocksTableViewCellDelegate

extension MainViewController: StocksTableViewCellDelegate {
    func favouriteStockSelected(state: Bool, ticker: String?, logoUrl: String?, name: String?) {
        mainPageManager.favouriteSelected(ticker: ticker, state: state)
        if isSearching {
            setSearchView(textField: searchBar)
        }
    }
}

//MARK: - StockButtonViewDelegate

extension MainViewController: StockButtonsViewDelegate {
    func buttonTapped() {
        stocksTableView.reloadData()
    }
}

//MARK: - SearchTextFieldDelegate

extension MainViewController: SearchBarDelegate {
    func cancelButtonTapped() {
        hidePopularRequestsView()
        backToMainPage()
        stocksTableView.reloadData()
    }
    
    func textFieldShouldReturn(textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.hasText {
            hidePopularRequestsView()
            setSearchView(textField: textField)
        } else {
            setPopularRequestsView()
        }
    }
    
    func textFieldDidChanged(textField: UITextField) {
        if searchBar.hasText {
            hidePopularRequestsView()
            setSearchView(textField: textField)
        } else {
            setPopularRequestsView()
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if searchBar.hasText {
            setSearchView(textField: textField)
        } else {
            hidePopularRequestsView()
            backToMainPage()
        }
        stocksTableView.reloadData()
    }
}

//MARK: - Set Searching View

extension MainViewController {
    private func setSearchView(textField: UITextField) {
        setNewConstraintsStocksTableView()
        isSearching = true
        guard let string = textField.text else { return }
        let newString = Array(string.lowercased())
        mainPageManager.findSearchStocks(newString: newString)
        stocksTableView.reloadData()
    }
    
    private func backToMainPage() {
        isSearching = false
        mainPageManager.removeSearchModel()
        buttonView.stocksButton.isHidden = false
        buttonView.favouriteButton.isHidden = false
        setOldConstraintsStocksTableView()
    }
    
    private func setNewConstraintsStocksTableView() {
        view.addSubview(stocksTableView)
        NSLayoutConstraint.activate([
            stocksTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            stocksTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stocksTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stocksTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setOldConstraintsStocksTableView() {
        stocksTableView.removeFromSuperview()
        view.addSubview(stocksTableView)
        NSLayoutConstraint.activate([
            stocksTableView.topAnchor.constraint(equalTo: buttonView.bottomAnchor),
            stocksTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stocksTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stocksTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        view.layoutIfNeeded()
        view.layoutSubviews()
    }
}

//MARK: - Set Popular Requests View

extension MainViewController {
    private func setPopularRequestsView() {
        buttonView.stocksButton.isHidden = true
        buttonView.favouriteButton.isHidden = true
        stocksTableView.removeFromSuperview()
        view.addSubview(popularRequestsPage)
        NSLayoutConstraint.activate([
            popularRequestsPage.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 40),
            popularRequestsPage.leadingAnchor.constraint(equalTo: searchBar.leadingAnchor),
            popularRequestsPage.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor),
            popularRequestsPage.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func hidePopularRequestsView() {
        popularRequestsPage.removeFromSuperview()
    }
}

extension MainViewController: SearchPopularRequestsPageDelegate {
    func searchForTheCompanyByTitle(title: String) {
        searchBar.text = title
        isSearching = true
        textFieldDidChanged(textField: searchBar)
        stocksTableView.reloadData()
    }
}

//MARK: - JSONReaderDelegate

extension MainViewController: MainPageManagerDelegate {
    func reloadStocksTableView() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        stocksTableView.isHidden = false
        setOldConstraintsStocksTableView()
        DispatchQueue.main.async {
            self.stocksTableView.reloadData()
        }
    }
}

//MARK: - ChartsViewControllerDelegate

extension MainViewController: ChartsViewControllerDelegate {
    func changeFavouriteState(ticker: String?, state: Bool) {
        guard let ticker else { return }
        mainPageManager.favouriteSelected(ticker: ticker, state: state)
        if isSearching {
            setSearchView(textField: searchBar)
        }
    }
}

/*
 
 Questions:
    1. CoreData
    2. Refactoring
 
 */
