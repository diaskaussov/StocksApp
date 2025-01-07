import UIKit
import DGCharts

protocol ChartsViewControllerDelegate {
    func changeFavouriteState(ticker: String?, state: Bool)
}

final class ChartsViewController: UIViewController {
    var delegate: ChartsViewControllerDelegate?
    var presenter: ChartsPresenter
    
    init(presenter: ChartsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setButtonProperties()
        setStockInfo()
        addSubViews()
        setupLayout()
    }
    
    private let lineChartView: LineChartView = {
        let view = LineChartView()
        view.rightAxis.enabled = false
        view.leftAxis.enabled = false
        view.xAxis.enabled = false
        view.chartDescription.enabled = false
        view.legend.enabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let topView = TopView()
    
    private let menuView = MenuView()
    
    private let chartButtonsView = ChartButtonsView()
    
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
        let currentPrice = presenter.getCurrentPrice()
        buyButton.setTitle("Buy for $\(currentPrice)", for: .normal)
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
    
    let y: [ChartDataEntry] = [
        ChartDataEntry(x: 0.0, y: 2.0),
        ChartDataEntry(x: 1.0, y: 3.0),
        ChartDataEntry(x: 2.0, y: 4.0),
        ChartDataEntry(x: 3.0, y: 25.0),
        ChartDataEntry(x: 4.0, y: 212.0),
        ChartDataEntry(x: 5.0, y: 2.0),
        ChartDataEntry(x: 6.0, y: 211.0),
        ChartDataEntry(x: 7.0, y: 23.0),
        ChartDataEntry(x: 8.0, y: 5.0),
        ChartDataEntry(x: 9.0, y: 6.0),
        ChartDataEntry(x: 10.0, y: 223.0),
        ChartDataEntry(x: 11.0, y: 35.0),
        ChartDataEntry(x: 12.0, y: 46.0),
        ChartDataEntry(x: 13.0, y: 23.0),
        ChartDataEntry(x: 14.0, y: 53.0),
        ChartDataEntry(x: 15.0, y: 78.0)
    ]

}

extension ChartsViewController {
    private func setStockInfo() {
        topView.stockTicker.text = presenter.getStockTicker()
        topView.stockName.text = presenter.getStockName()
        topView.starButton.isSelected = presenter.getStockState()
        topView.starButton.tintColor = presenter.getStarButtonColor(sender: topView.starButton.isSelected)
        setData()
        presenter.getStockPrices()
    }
    
    private func addSubViews() {
        view.addSubview(topView)
        view.addSubview(lineChartView)
        view.addSubview(menuView)
        view.addSubview(chartButtonsView)
        view.addSubview(buyButton)
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
            
            buyButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            buyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buyButton.heightAnchor.constraint(equalToConstant: 60),
            
            chartButtonsView.bottomAnchor.constraint(equalTo: buyButton.topAnchor, constant: -50),
            chartButtonsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            chartButtonsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            chartButtonsView.heightAnchor.constraint(equalToConstant: 50),
            
            lineChartView.bottomAnchor.constraint(equalTo: chartButtonsView.topAnchor, constant: -40),
            lineChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lineChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lineChartView.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
    
}

extension ChartsViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
    func setData() {
        let set1 = LineChartDataSet(entries: y, label: "")
        set1.mode = .cubicBezier
        set1.drawCirclesEnabled = false
        set1.lineWidth = 2
        set1.setColor(.black)
        set1.fillColor = .gray
        set1.fillAlpha = 0.05
        set1.drawFilledEnabled = true
        
        let data = LineChartData(dataSets: [set1])
        data.setDrawValues(false)
        lineChartView.data = data
    }
}
/*

 To-do's:
 1) View for
    i) MenuStack
    ii) ChartStack & delegate when tapped
 2) Presenter logic

*/


/*
 What was before:
 
       private let topView: UIView {
           let view = UIView()
           view.translatesAutoresizingMaskIntoConstraints = false
           return view
       }()
 
 //    private lazy var backButton: UIButton = {
 //        let button = UIButton()
           button.tintColor = .black
           button.setImage(UIImage(systemName: "arrowshape.backward"), for: .normal)
           button.addTarget(self, action: #selector(backToMainViewController), for: .touchUpInside)
           button.translatesAutoresizingMaskIntoConstraints = false
 //        return button
 //    }()
 
//    private lazy var starButton: UIButton = {
//        let button = UIButton()
//        button.tintColor = .black
//        button.setImage(UIImage(systemName: "star.fill"), for: .normal)
//        button.addTarget(self, action: #selector(makeFavourite), for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//
//    private let stockTicker: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    private let stockName: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()

 */
