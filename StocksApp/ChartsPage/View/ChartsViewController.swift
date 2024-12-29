import UIKit

protocol ChartsViewControllerDelegate {
    func changeFavouriteState(ticker: String?, state: Bool)
    func reloadTableView()
}

class ChartsViewController: UIViewController {
    
    private let stock: StockModel
    var delegate: ChartsViewControllerDelegate?
    
    init(stock: StockModel) {
        self.stock = stock
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setButtonProperties()
        setUI()
    }
    
    private let topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.setImage(UIImage(systemName: "arrowshape.backward"), for: .normal)
        button.addTarget(self, action: #selector(backToMainViewController), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var starButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.setImage(UIImage(systemName: "star.fill"), for: .normal)
        button.addTarget(self, action: #selector(makeFavourite), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let stockTicker: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stockName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let menuStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let menuScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let chartStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 13
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    private lazy var chartButton = MenuButton(title: "Chart")
    private lazy var summaryButton = MenuButton(title: "Summary")
    private lazy var newsButton = MenuButton(title: "News")
    private lazy var forecastsButton = MenuButton(title: "Forecasts")
    private lazy var ideasButton = MenuButton(title: "Ideas")
    
    private lazy var dayButton = ChartButton(name: "D")
    private lazy var weekButton = ChartButton(name: "W")
    private lazy var monthButton = ChartButton(name: "M")
    private lazy var halfYearButton = ChartButton(name: "6M")
    private lazy var yearButton = ChartButton(name: "1Y")
    private lazy var allButton = ChartButton(name: "All")
    
    private lazy var buyButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private func setButtonProperties() {
        guard let currentPrice = stock.currentPrice else { return }
        buyButton.setTitle("Buy for $\(currentPrice)", for: .normal)
        
        makeFontSelected(chartButton)
        chartButton.addTarget(self, action: #selector(menuButtonSelected), for: .touchUpInside)
        summaryButton.addTarget(self, action: #selector(menuButtonSelected), for: .touchUpInside)
        newsButton.addTarget(self, action: #selector(menuButtonSelected), for: .touchUpInside)
        forecastsButton.addTarget(self, action: #selector(menuButtonSelected), for: .touchUpInside)
        ideasButton.addTarget(self, action: #selector(menuButtonSelected), for: .touchUpInside)
        
        chartButtonSelected(allButton)
        dayButton.addTarget(self, action: #selector(chartButtonTapped), for: .touchUpInside)
        weekButton.addTarget(self, action: #selector(chartButtonTapped), for: .touchUpInside)
        monthButton.addTarget(self, action: #selector(chartButtonTapped), for: .touchUpInside)
        halfYearButton.addTarget(self, action: #selector(chartButtonTapped), for: .touchUpInside)
        yearButton.addTarget(self, action: #selector(chartButtonTapped), for: .touchUpInside)
        allButton.addTarget(self, action: #selector(chartButtonTapped), for: .touchUpInside)
    }
    
    private func setStarButtonColor(sender: UIButton) {
        if sender.isSelected {
            sender.tintColor = UIColor(
                red: 254.0/255.0,
                green: 190.0/255.0,
                blue: 0,
                alpha: 1
            )
        } else {
            sender.tintColor = .gray
        }
    }
    
    @objc
    private func makeFavourite(_ sender: UIButton) {
        if sender.isSelected {
            sender.tintColor = .gray
            sender.isSelected = false
        } else {
            sender.tintColor = UIColor(
                red: 254.0/255.0,
                green: 190.0/255.0,
                blue: 0,
                alpha: 1
            )
            sender.isSelected = true
        }
        delegate?.changeFavouriteState(ticker: stockTicker.text, state: sender.isSelected)
    }
    
    @objc
    private func backToMainViewController(sender: UIButton) {
        delegate?.reloadTableView()
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func menuButtonSelected(_ sender: UIButton) {
        guard let title = sender.titleLabel?.text else { return }
        
        makeFontSelected(sender)
        
        switch(title) {
        case "Summary":
            makeFontDefault(chartButton)
            makeFontDefault(newsButton)
            makeFontDefault(forecastsButton)
            makeFontDefault(ideasButton)
        case "News":
            makeFontDefault(chartButton)
            makeFontDefault(summaryButton)
            makeFontDefault(forecastsButton)
            makeFontDefault(ideasButton)
        case "Forecasts":
            makeFontDefault(chartButton)
            makeFontDefault(summaryButton)
            makeFontDefault(newsButton)
            makeFontDefault(ideasButton)
        case "Ideas":
            makeFontDefault(chartButton)
            makeFontDefault(summaryButton)
            makeFontDefault(newsButton)
            makeFontDefault(forecastsButton)
        default: //"Chart"
            makeFontDefault(summaryButton)
            makeFontDefault(newsButton)
            makeFontDefault(forecastsButton)
            makeFontDefault(ideasButton)
        }
    }
    
    private func makeFontDefault(_ sender: UIButton) {
        sender.titleLabel?.font = .systemFont(ofSize: 18)
        sender.setTitleColor(.gray, for: .normal)
    }
    
    private func makeFontSelected(_ sender: UIButton) {
        sender.titleLabel?.font = .systemFont(
            ofSize: 20,
            weight: .bold
        )
        sender.setTitleColor(.black, for: .normal)
    }
    
    @objc
    private func chartButtonTapped(_ sender: UIButton) {
        guard let title = sender.titleLabel?.text else { return }
        
        chartButtonSelected(sender)
        
        switch(title) {
        case "D":
            chartButtonDefault(weekButton)
            chartButtonDefault(monthButton)
            chartButtonDefault(halfYearButton)
            chartButtonDefault(yearButton)
            chartButtonDefault(allButton)
        case "W":
            chartButtonDefault(dayButton)
            chartButtonDefault(monthButton)
            chartButtonDefault(halfYearButton)
            chartButtonDefault(yearButton)
            chartButtonDefault(allButton)
        case "M":
            chartButtonDefault(dayButton)
            chartButtonDefault(weekButton)
            chartButtonDefault(halfYearButton)
            chartButtonDefault(yearButton)
            chartButtonDefault(allButton)
        case "6M":
            chartButtonDefault(dayButton)
            chartButtonDefault(weekButton)
            chartButtonDefault(monthButton)
            chartButtonDefault(yearButton)
            chartButtonDefault(allButton)
        case "1Y":
            chartButtonDefault(dayButton)
            chartButtonDefault(weekButton)
            chartButtonDefault(monthButton)
            chartButtonDefault(halfYearButton)
            chartButtonDefault(allButton)
        default: // "All"
            chartButtonDefault(dayButton)
            chartButtonDefault(weekButton)
            chartButtonDefault(monthButton)
            chartButtonDefault(halfYearButton)
            chartButtonDefault(yearButton)
        }
    }
    
    private func chartButtonDefault(_ sender: UIButton) {
        sender.backgroundColor = .systemGray6
        sender.setTitleColor(.black, for: .normal)
    }
    
    private func chartButtonSelected(_ sender: UIButton) {
        sender.backgroundColor = .black
        sender.setTitleColor(.white, for: .normal)
    }
}

extension ChartsViewController {
    private func setUI() {
        setStockInfo()
        addSubViews()
        setupLayout()
    }
}

extension ChartsViewController {
    private func setStockInfo() {
        stockTicker.text = stock.jsonModel.ticker
        stockName.text = stock.jsonModel.name
        starButton.isSelected = stock.isFavourite
        setStarButtonColor(sender: starButton)
    }
    
    private func addSubViews() {
        view.addSubview(topView)
        view.addSubview(menuScrollView)
        view.addSubview(chartStack)
        view.addSubview(buyButton)
        menuScrollView.addSubview(menuStack)
        topView.addSubview(backButton)
        topView.addSubview(stockTicker)
        topView.addSubview(stockName)
        topView.addSubview(starButton)
        menuStack.addArrangedSubview(chartButton)
        menuStack.addArrangedSubview(summaryButton)
        menuStack.addArrangedSubview(newsButton)
        menuStack.addArrangedSubview(forecastsButton)
        menuStack.addArrangedSubview(ideasButton)
        chartStack.addArrangedSubview(dayButton)
        chartStack.addArrangedSubview(weekButton)
        chartStack.addArrangedSubview(monthButton)
        chartStack.addArrangedSubview(halfYearButton)
        chartStack.addArrangedSubview(yearButton)
        chartStack.addArrangedSubview(allButton)
    }
}

extension ChartsViewController {
    private func setupLayout() {
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 70),
            
            backButton.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 20),
            backButton.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            
            stockTicker.centerYAnchor.constraint(equalTo: topView.centerYAnchor, constant: -15),
            stockTicker.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            
            stockName.centerYAnchor.constraint(equalTo: topView.centerYAnchor, constant: 15),
            stockName.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            
            starButton.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -20),
            starButton.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            
            menuScrollView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            menuScrollView.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            menuScrollView.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            menuScrollView.heightAnchor.constraint(equalToConstant: 50),
            
            menuStack.topAnchor.constraint(equalTo: menuScrollView.contentLayoutGuide.topAnchor),
            menuStack.leadingAnchor.constraint(equalTo: menuScrollView.contentLayoutGuide.leadingAnchor, constant: 5),
            menuStack.trailingAnchor.constraint(equalTo: menuScrollView.contentLayoutGuide.trailingAnchor, constant: -5),
            menuStack.heightAnchor.constraint(equalToConstant: 50),
            
            buyButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            buyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buyButton.heightAnchor.constraint(equalToConstant: 60),
            
            chartStack.bottomAnchor.constraint(equalTo: buyButton.topAnchor, constant: -60),
            chartStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            chartStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            chartStack.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
