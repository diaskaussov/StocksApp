//
//  SearchPopularRequestsButton.swift
//  StocksApp
//
//  Created by Dias Kaussov on 31.12.2024.
//

import UIKit

protocol PopularRequestsButtonDelegate {
    func searchPopularRequests(text: String)
}

final class PopularRequestsButton: UIButton {
    
    var popularRequestsButtonDelegate: PopularRequestsButtonDelegate?
    
    init(text: String) {
        super.init(frame: .zero)
        setButtonProperties(title: text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setButtonProperties(title: String) {
        setTitle(title, for: .normal)
        contentEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        
//        var configuration = UIButton.Configuration.plain() // there are several options to choose from instead of .plain()
//        configuration.contentInsets = NSDirectionalEdgeInsets(top: 24, leading: 24, bottom: 24, trailing: 24)
//        button.configuration = configuration
        
        titleLabel?.font = .systemFont(ofSize: 14)
        setTitleColor(.black, for: .normal)
        backgroundColor = .systemGray6
        layer.cornerRadius = 16
        addTarget(self, action: #selector(popularRequestsButtonSelected), for: .touchUpInside)
    }
    
    @objc
    private func popularRequestsButtonSelected(_ sender: UIButton) {
        guard let title = sender.titleLabel?.text else { return }
        popularRequestsButtonDelegate?.searchPopularRequests(text: title)
    }
}
