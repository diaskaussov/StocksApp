//
//  ViewController.swift
//  StocksApp
//
//  Created by Dias Kaussov on 15.11.2024.
//

import UIKit

final class MainViewController: UIViewController {
    var number = 20
    let jsonReader = JSONReader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private let stocksTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(StocksTableViewCell.self, forCellReuseIdentifier: StocksTableViewCell.identifier)
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
                    font: .systemFont(ofSize: 28.0)
                )
            ),
            for: .normal
        )
        button.tintColor = .black
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var searchTextField =
    SearchTextField(
        placeholder: "Find company or ticker",
        button: searchButton
    )
    
    private lazy var stocksButton: UIButton = {
        let button = UIButton()
        button.setTitle("Stocks", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 36, weight: .bold)
        button.isSelected = true
        button.addTarget(nil, action: #selector(buttonSelected), for: .touchUpInside)
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
        button.addTarget(nil, action: #selector(buttonSelected), for: .touchUpInside)
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
    
    private func makeFontDefault(_ sender: UIButton) {
        sender.titleLabel?.font = .systemFont(ofSize: 24, weight: .semibold)
        sender.setTitleColor(.gray, for: .normal)
    }
    
    private func makeFontSelected(_ sender: UIButton) {
        sender.titleLabel?.font = .systemFont(
            ofSize: 36,
            weight: .bold
        )
        sender.setTitleColor(
            .black,
            for: .normal
        )
    }
}

private extension MainViewController {
    func setupUI() {
        view.backgroundColor = .white
        addSubViews()
        setupLayout()
        setDelegates()
    }
}

private extension MainViewController {
    func addSubViews() {
        view.addSubview(searchTextField)
        view.addSubview(buttonView)
        view.addSubview(stocksTableView)
        buttonView.addSubview(stocksButton)
        buttonView.addSubview(favouriteButton)
    }
}

private extension MainViewController {
    func setupLayout() {
        self.navigationController?.navigationBar.isHidden = true
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchTextField.heightAnchor.constraint(equalToConstant: 65),
            
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

private extension MainViewController {
    func setDelegates() {
        stocksTableView.delegate = self
        stocksTableView.dataSource = self
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteButton.isSelected ? jsonReader.getNumberOfFavouriteCells() : number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: StocksTableViewCell.identifier,
            for: indexPath
        ) as? StocksTableViewCell else { fatalError("Error dequeueing cell") }
        
        cell.setBackground(even: indexPath.row % 2 == 0)
        
        cell.delegate = self
        
        var stock: stockModel = jsonReader.models[indexPath.row]
        
        if favouriteButton.isSelected {
            jsonReader.getFavouriteStocks()
            print(jsonReader.favouriteModels)
            stock = jsonReader.favouriteModels[indexPath.row]
        }
        
        cell.configure(name: stock.jsonModel.name,
                           ticker: stock.jsonModel.ticker,
                           index: indexPath.row,
                           state: stock.isFavourite
        )
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
}

extension MainViewController: StocksTableViewCellDelegate {
    func favouriteStockSelected(state: Bool, index: Int) {
        jsonReader.models[index].isFavourite = state
    }
}
