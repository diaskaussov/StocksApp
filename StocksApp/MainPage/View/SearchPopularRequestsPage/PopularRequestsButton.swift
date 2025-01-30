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
        layer.cornerRadius = 16
        setTitle(title, for: .normal)
        backgroundColor = .systemGray6
        setTitleColor(.black, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 14)
        contentEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10) // Did not find replacement
        addTarget(self, action: #selector(popularRequestsButtonSelected), for: .touchUpInside)
    }
    
    @objc
    private func popularRequestsButtonSelected(_ sender: UIButton) {
        guard let title = sender.titleLabel?.text else { return }
        popularRequestsButtonDelegate?.searchPopularRequests(text: title)
    }
}
