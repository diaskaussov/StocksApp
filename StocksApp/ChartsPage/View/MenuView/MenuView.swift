    //
//  MenuView.swift
//  StocksApp
//
//  Created by Dias Kaussov on 30.12.2024.
//
import UIKit

class MenuView: UIView {
    private lazy var chartButton = MenuButton(title: "Chart")
    private lazy var summaryButton = MenuButton(title: "Summary")
    private lazy var newsButton = MenuButton(title: "News")
    private lazy var forecastsButton = MenuButton(title: "Forecasts")
    private lazy var ideasButton = MenuButton(title: "Ideas")
    
    init() {
        super.init(frame: .zero)
        setButtonProperties()
        addSubviews()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    private func setButtonProperties() {
        makeFontSelected(chartButton)
        chartButton.addTarget(self, action: #selector(menuButtonSelected), for: .touchUpInside)
        summaryButton.addTarget(self, action: #selector(menuButtonSelected), for: .touchUpInside)
        newsButton.addTarget(self, action: #selector(menuButtonSelected), for: .touchUpInside)
        forecastsButton.addTarget(self, action: #selector(menuButtonSelected), for: .touchUpInside)
        ideasButton.addTarget(self, action: #selector(menuButtonSelected), for: .touchUpInside)
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
    
    private func addSubviews() {
        self.addSubview(menuScrollView)
        menuScrollView.addSubview(menuStack)
        menuStack.addArrangedSubview(chartButton)
        menuStack.addArrangedSubview(summaryButton)
        menuStack.addArrangedSubview(newsButton)
        menuStack.addArrangedSubview(forecastsButton)
        menuStack.addArrangedSubview(ideasButton)
    }
    
    private func setLayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            menuScrollView.topAnchor.constraint(equalTo: self.topAnchor),
            menuScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            menuScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            menuScrollView.heightAnchor.constraint(equalToConstant: 50),
            
            menuStack.topAnchor.constraint(equalTo: menuScrollView.contentLayoutGuide.topAnchor),
            menuStack.leadingAnchor.constraint(equalTo: menuScrollView.contentLayoutGuide.leadingAnchor, constant: 5),
            menuStack.trailingAnchor.constraint(equalTo: menuScrollView.contentLayoutGuide.trailingAnchor, constant: -5),
            menuStack.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
}
