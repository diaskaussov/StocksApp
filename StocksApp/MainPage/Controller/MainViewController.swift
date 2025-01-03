//
//  ViewController.swift
//  StocksApp
//
//  Created by Dias Kaussov on 15.11.2024.
//

import UIKit

final class MainViewController: UIViewController {
    var lowerIndex = 0
    var upperIndex = 20
    
    private let jsonReader = JSONReader()
    
    private lazy var popularRequestsView = SearchPopularRequestsPage(stocks: jsonReader.stockModels)
    
    private lazy var searchTextField =
    SearchTextField(
        placeholder: "Find company or ticker",
        leftButton: searchButton,
        rightButton: cancelButton
    )
   
    private var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stocksTableView.reloadData()
    }
    
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
    
    private let buttonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton()
        button.setImage(
            UIImage(
                systemName: "magnifyingglass",
                withConfiguration: UIImage.SymbolConfiguration(
                    font: .systemFont(ofSize: 20.0, weight: .semibold)
                )
            ),
            for: .normal
        )
        button.tintColor = .black
        button.addTarget(nil, action: #selector(startSearch), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(
            UIImage(
                systemName: "x.circle",
                withConfiguration: UIImage.SymbolConfiguration(
                    font: .systemFont(ofSize: 20.0, weight: .semibold)
                )
            ),
            for: .normal
        )
        button.tintColor = .black
        button.addTarget(nil, action: #selector(cancelText), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var stocksButton: UIButton = {
        let button = UIButton()
        button.setTitle("Stocks", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 36, weight: .bold)
        button.isSelected = true
        button.addTarget(self, action: #selector(buttonSelected), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var favouriteButton: UIButton = {
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
        stocksTableView.reloadData()
    }
    
    @objc
    private func cancelText(_ sender: UIButton) {
        searchTextField.resignFirstResponder()
    }
    
    private func makeFontDefault(_ sender: UIButton) {
        sender.titleLabel?.font = .systemFont(
            ofSize: 24,
            weight: .semibold
        )
        sender.setTitleColor(.gray, for: .normal)
    }
    
    @objc
    private func startSearch(_ sender: UIButton) {
        searchTextField.resignFirstResponder() //resign ??
    }
    
    private func makeFontSelected(_ sender: UIButton) {
        sender.titleLabel?.font = .systemFont(
            ofSize: 36,
            weight: .bold
        )
        sender.setTitleColor(.black, for: .normal)
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
        view.addSubview(searchTextField)
        view.addSubview(buttonView)
        view.addSubview(stocksTableView)
        buttonView.addSubview(stocksButton)
        buttonView.addSubview(favouriteButton)
    }
    
    private func setDelegates() {
        stocksTableView.delegate = self
        stocksTableView.dataSource = self
        searchTextField.searchTextFielDelegate = self
        jsonReader.delegate = self
    }
}

private extension MainViewController {
    func setupLayout() {
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchTextField.heightAnchor.constraint(equalToConstant: 50),
            
            buttonView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor),
            buttonView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonView.heightAnchor.constraint(equalToConstant: 90),
            
            stocksButton.topAnchor.constraint(equalTo: buttonView.topAnchor),
            stocksButton.leadingAnchor.constraint(equalTo: buttonView.leadingAnchor, constant: 10),
            stocksButton.heightAnchor.constraint(equalToConstant: 90),
            stocksButton.widthAnchor.constraint(equalToConstant: 150),
            
            favouriteButton.topAnchor.constraint(equalTo: buttonView.topAnchor),
            favouriteButton.leadingAnchor.constraint(equalTo: stocksButton.trailingAnchor),
            favouriteButton.heightAnchor.constraint(equalToConstant: 90),
            favouriteButton.widthAnchor.constraint(equalToConstant: 200),
            
            stocksTableView.topAnchor.constraint(equalTo: buttonView.bottomAnchor),
            stocksTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stocksTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stocksTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if favouriteButton.isSelected {
            return jsonReader.getNumberOfFavouriteCells()
        } else if isSearching {
            return jsonReader.getNumberOfSearchingCells()
        }
        return upperIndex - lowerIndex + 1
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tableView.numberOfRows(inSection: 0) {
            
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
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
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
        if favouriteButton.isSelected {
            jsonReader.findFavouriteStocks()
            return jsonReader.favouriteModels[index]
        } else if jsonReader.searchModels.isEmpty == false {
            return jsonReader.searchModels[index]
        } else {
            return jsonReader.getModel(index: index)
        }
    }
}

//MARK: - StocksTableViewCellDelegate

extension MainViewController: StocksTableViewCellDelegate {
    func favouriteStockSelected(state: Bool, ticker: String?) {
        jsonReader.favouriteSelected(ticker: ticker, state: state)
    }
}

//MARK: - SearchTextFieldDelegate

extension MainViewController: SearchTextFieldDelegate {
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
        if searchTextField.hasText {
            hidePopularRequestsView()
            setSearchView(textField: textField)
        } else {
            setPopularRequestsView()
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if searchTextField.hasText {
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
        let newString = Array(string.uppercased())
        jsonReader.findSearchStocks(newString: newString)
        stocksTableView.reloadData()
    }
    
    private func backToMainPage() {
        isSearching = false
        jsonReader.removeSearchModel()
        stocksButton.isHidden = false
        favouriteButton.isHidden = false
        setOldConstraintsStocksTableView()
    }
    
    private func setNewConstraintsStocksTableView() {
        view.addSubview(stocksTableView)
        NSLayoutConstraint.activate([
            stocksTableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
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
        stocksButton.isHidden = true
        favouriteButton.isHidden = true
        stocksTableView.removeFromSuperview()
        view.addSubview(popularRequestsView)
        NSLayoutConstraint.activate([
            popularRequestsView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 40),
            popularRequestsView.leadingAnchor.constraint(equalTo: searchTextField.leadingAnchor),
            popularRequestsView.trailingAnchor.constraint(equalTo: searchTextField.trailingAnchor),
            popularRequestsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func hidePopularRequestsView() {
        popularRequestsView.removeFromSuperview()
    }
}

//MARK: - JSONReaderDelegate

extension MainViewController: JSONReaderDelegate {
    func reloadStocksTableView() {
        DispatchQueue.main.async {
            self.stocksTableView.reloadData()
        }
    }
}


//MARK: - ChartsViewControllerDelegate

extension MainViewController: ChartsViewControllerDelegate {
    func changeFavouriteState(ticker: String?, state: Bool) {
        guard let ticker else { return }
        jsonReader.favouriteSelected(ticker: ticker, state: state)
    }
    func reloadTableView() {
        stocksTableView.reloadData()
    }
}

/*
 Questions:
 2) CancelButton & SearchButton - ?
 6) StackView or CollectionView (Search) - StackView
 7) MVP?, refactoring?
 7) Persistence
 8) Core Data
 9) Chart
*/
