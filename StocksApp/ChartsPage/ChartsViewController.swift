import UIKit
import DGCharts

protocol ChartsViewControllerDelegate {
    func changeFavouriteState(ticker: String?, state: Bool)
}

final class ChartsViewController: UIViewController {
    var delegate: ChartsViewControllerDelegate?
    var presenter: ChartsPresenter
    var dataAvailable = false
    init(presenter: ChartsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        presenter.chartPresenterDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        chartButtonsView.chartButtonsViewDelegate = self
        setButtonProperties()
        setStockInfo()
        addSubViews()
        setupLayout()
        setData()
        setMarker()
    }
    
    private let lineChartView = StockLineChartView()
    
    private let topView = TopView()
    
    private let menuView = MenuView()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let chartButtonsView = ChartButtonsView()
    
    private let activityIndicator : UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
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
        topView.backButton.addTarget(self, action: #selector(backToMainViewController), for: .touchUpInside)
        topView.starButton.addTarget(self, action: #selector(makeFavourite), for: .touchUpInside)
    }
    
    @objc
    private func makeFavourite(_ button: UIButton) {
        button.isSelected.toggle()
        button.tintColor = presenter.getStarButtonColor(sender: button.isSelected)
        delegate?.changeFavouriteState(ticker: topView.stockTicker.text, state: button.isSelected)
    }
    
    @objc
    private func backToMainViewController(sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension ChartsViewController {
    private func setStockInfo() {
        topView.stockTicker.text = presenter.getStockTicker()
        topView.stockName.text = presenter.getStockName()
        topView.starButton.isSelected = presenter.getStockState()
        topView.starButton.tintColor = presenter.getStarButtonColor(sender: topView.starButton.isSelected)
        priceLabel.text = String(format: "$ %.2f", presenter.getCurrentPrice())
        buyButton.setTitle(String(format: "Buy for $ %.2f", presenter.getCurrentPrice()), for: .normal)
    }
    
    private func addSubViews() {
        view.addSubview(topView)
        view.addSubview(lineChartView)
        view.addSubview(menuView)
        view.addSubview(priceLabel)
        view.addSubview(chartButtonsView)
        view.addSubview(buyButton)
        view.addSubview(activityIndicator)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 70),
            
            menuView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            menuView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuView.heightAnchor.constraint(equalToConstant: 50),
            
            priceLabel.topAnchor.constraint(equalTo: menuView.bottomAnchor, constant: 10),
            priceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
            priceLabel.heightAnchor.constraint(equalToConstant: 80),
            
            buyButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            buyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buyButton.heightAnchor.constraint(equalToConstant: 60),
            
            chartButtonsView.bottomAnchor.constraint(equalTo: buyButton.topAnchor, constant: -50),
            chartButtonsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            chartButtonsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            chartButtonsView.heightAnchor.constraint(equalToConstant: 50),
            
            lineChartView.bottomAnchor.constraint(equalTo: chartButtonsView.topAnchor, constant: -40),
            lineChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -8),
            lineChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 8),
            lineChartView.heightAnchor.constraint(equalToConstant: 350),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension ChartsViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("Entry: \(entry)")
    }
    
    func setData() {
        if !dataAvailable {
            activityIndicator.startAnimating()
            lineChartView.isHidden = true
        } else {
            let numberOfDays = chartButtonsView.numberOfDays
            if numberOfDays == 1 {
                setMarkerForIntraday()
            } else {
                setMarker()
            }
            let set1 = LineChartDataSet(
                entries: presenter.getStockData(numberOfDays: chartButtonsView.numberOfDays),
                label: ""
            )
            set1.mode = .cubicBezier
            set1.drawCirclesEnabled = false
            set1.lineWidth = 2
            set1.setColor(.black)
            set1.drawFilledEnabled = true
            set1.drawVerticalHighlightIndicatorEnabled = false
            set1.drawHorizontalHighlightIndicatorEnabled = false
            set1.fill = LinearGradientFill(gradient: self.presenter.getGradientFilling(),angle: 90)
            
            let data = LineChartData(dataSets: [set1])
            data.setDrawValues(false)
            DispatchQueue.main.async { [self] in
                self.lineChartView.data = data
                self.lineChartView.isHidden = false
                self.activityIndicator.stopAnimating()
            }
        }
    }
    func setMarker() {
        let marker = RectMarker(
            color: .black,
            font: UIFont.systemFont(ofSize: CGFloat(12.0)),
            insets: UIEdgeInsets(top: 8.0, left: 20, bottom: 4.0, right: 0),
            flag: false
        )
        marker.chartView = lineChartView
        marker.minimumSize = CGSize(width: CGFloat(60.0), height: CGFloat(30.0))
        lineChartView.marker = marker
    }
    
    func setMarkerForIntraday() {
        let marker = RectMarker(
            color: .black,
            font: UIFont.systemFont(ofSize: CGFloat(12.0)),
            insets: UIEdgeInsets(top: 8.0, left: 20, bottom: 4.0, right: 0),
            flag: true
        )
        marker.chartView = lineChartView
        marker.minimumSize = CGSize(width: CGFloat(60.0), height: CGFloat(30.0))
        lineChartView.marker = marker
    }
}

extension ChartsViewController: ChartsPresenterDelegate {
    func drawChartLine() {
        dataAvailable = true
        setData()
    }
}

extension ChartsViewController: ChartsButtonsViewDelegate {
    func updateNumberOfDays() {
        setData()
    }
}
