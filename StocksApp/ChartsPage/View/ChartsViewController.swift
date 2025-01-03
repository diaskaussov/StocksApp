import UIKit
import Charts
//import TinyConstraints

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
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let topView = TopView()
    
    private let menuView = MenuView()
    
    private let chartView = ChartView()
    
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
}

extension ChartsViewController {
    private func setStockInfo() {
        topView.stockTicker.text = presenter.getStockTicker()
        topView.stockName.text = presenter.getStockName()
        topView.starButton.isSelected = presenter.getStockState()
        topView.starButton.tintColor = presenter.getStarButtonColor(sender: topView.starButton.isSelected)
    }
    
    private func addSubViews() {
        view.addSubview(topView)
        view.addSubview(lineChartView)
        view.addSubview(menuView)
        view.addSubview(chartView)
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
            
            lineChartView.topAnchor.constraint(equalTo: menuView.bottomAnchor, constant: 20),
            lineChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lineChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lineChartView.heightAnchor.constraint(equalToConstant: 100),
            
            buyButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            buyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buyButton.heightAnchor.constraint(equalToConstant: 60),
            
            chartView.bottomAnchor.constraint(equalTo: buyButton.topAnchor, constant: -50),
            chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            chartView.heightAnchor.constraint(equalToConstant: 50)
        ])
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
