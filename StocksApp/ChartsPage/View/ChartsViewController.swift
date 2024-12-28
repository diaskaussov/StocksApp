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
    
    private let chartStackButtons: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let chartScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var chartButton = ChartButton(title: "Chart")
    private lazy var summaryButton = ChartButton(title: "Summary")
    private lazy var newsButton = ChartButton(title: "News")
    private lazy var forecastsButton = ChartButton(title: "Forecasts")
    private lazy var ideasButton = ChartButton(title: "Ideas")
    
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
        view.addSubview(chartScrollView)
        chartScrollView.addSubview(chartStackButtons)
        topView.addSubview(backButton)
        topView.addSubview(stockTicker)
        topView.addSubview(stockName)
        topView.addSubview(starButton)
        chartStackButtons.addArrangedSubview(chartButton)
        chartStackButtons.addArrangedSubview(summaryButton)
        chartStackButtons.addArrangedSubview(newsButton)
        chartStackButtons.addArrangedSubview(forecastsButton)
        chartStackButtons.addArrangedSubview(ideasButton)
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
            
            chartScrollView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            chartScrollView.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            chartScrollView.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            chartScrollView.heightAnchor.constraint(equalToConstant: 50),
            
            chartStackButtons.topAnchor.constraint(equalTo: chartScrollView.contentLayoutGuide.topAnchor),
            chartStackButtons.leadingAnchor.constraint(equalTo: chartScrollView.contentLayoutGuide.leadingAnchor),
            chartStackButtons.trailingAnchor.constraint(equalTo: chartScrollView.contentLayoutGuide.trailingAnchor),
            chartStackButtons.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
