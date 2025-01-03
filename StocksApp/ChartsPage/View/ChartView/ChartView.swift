//
//  ChartView.swift
//  StocksApp
//
//  Created by Dias Kaussov on 30.12.2024.
//

import UIKit

final class ChartView: UIView {
    private lazy var dayButton = ChartButton(name: "D")
    private lazy var weekButton = ChartButton(name: "W")
    private lazy var monthButton = ChartButton(name: "M")
    private lazy var halfYearButton = ChartButton(name: "6M")
    private lazy var yearButton = ChartButton(name: "1Y")
    private lazy var allButton = ChartButton(name: "All")
    
    init() {
        super.init(frame: .zero)
        setButtonProperties()
        addSubviews()
        setLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let chartStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 13
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private func setButtonProperties() {
        chartButtonSelected(allButton)
        dayButton.addTarget(self, action: #selector(chartButtonTapped), for: .touchUpInside)
        weekButton.addTarget(self, action: #selector(chartButtonTapped), for: .touchUpInside)
        monthButton.addTarget(self, action: #selector(chartButtonTapped), for: .touchUpInside)
        halfYearButton.addTarget(self, action: #selector(chartButtonTapped), for: .touchUpInside)
        yearButton.addTarget(self, action: #selector(chartButtonTapped), for: .touchUpInside)
        allButton.addTarget(self, action: #selector(chartButtonTapped), for: .touchUpInside)
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
    
    private func addSubviews() {
        self.addSubview(chartStack)
        chartStack.addArrangedSubview(dayButton)
        chartStack.addArrangedSubview(weekButton)
        chartStack.addArrangedSubview(monthButton)
        chartStack.addArrangedSubview(halfYearButton)
        chartStack.addArrangedSubview(yearButton)
        chartStack.addArrangedSubview(allButton)
    }
    
    private func setLayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chartStack.topAnchor.constraint(equalTo: self.topAnchor),
            chartStack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            chartStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            chartStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            chartStack.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
