//
//  StocksTableViewCell.swift
//  StocksApp
//
//  Created by Dias Kaussov on 15.11.2024.
//

import UIKit

protocol StocksTableViewCellDelegate {
    func favouriteStockSelected(state: Bool, index: Int)
}

class StocksTableViewCell: UITableViewCell {
    static let identifier = "StocksTableViewCell"
    
    var index: Int?
    var delegate: StocksTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let photoImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "apple.logo")
        image.tintColor = .black
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 8
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let tickerLabel: UILabel = {
        let label = UILabel()
        label.text = "AAPL"
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Apple inc."
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let currentPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "$\(131.93)"
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let deltaPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "+$\(0.12)"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let percentageLabel: UILabel = {
        let label = UILabel()
        label.text = "(\(1.15)%)"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let starButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star.fill"), for: .normal)
        button.tintColor = .gray
        button.isSelected = false
        button.addTarget(nil, action: #selector(didSelected), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc
    private func didSelected(_ sender: UIButton) {
        if sender.tintColor == .gray {
            sender.tintColor = UIColor(red: 254.0/255.0,
                                       green: 190.0/255.0,
                                       blue: 0,
                                       alpha: 1
                                )
            sender.isSelected = true
        } else {
            sender.tintColor = .gray
            sender.isSelected = false
        }
        
        guard let newIndex = self.index else { return }
        
        delegate?.favouriteStockSelected(state: sender.isSelected, index: newIndex)
    }
    
    func setButtonColor(_ sender: UIButton) {
        if sender.isSelected {
            sender.tintColor = UIColor(red: 254.0/255.0,
                                       green: 190.0/255.0,
                                       blue: 0,
                                       alpha: 1
            )
        } else {
            sender.tintColor = .gray
        }
    }
    
    func setBackground(even: Bool) {
        if (even) {
            self.backgroundColor = .systemGray6
        } else {
            self.backgroundColor = .white
        }
    }
    
    func configure(name: String, ticker: String, index: Int, state: Bool) {
        nameLabel.text = name
        tickerLabel.text = ticker
        self.index = index
        starButton.isSelected = state
        setButtonColor(starButton)
    }
    
    private func setUI() {
        contentView.addSubview(photoImageView)
        contentView.addSubview(tickerLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(starButton)
        contentView.addSubview(currentPriceLabel)
        contentView.addSubview(deltaPriceLabel)
        contentView.addSubview(percentageLabel)
        
        self.layer.cornerRadius = 16
        
        NSLayoutConstraint.activate([
            
            self.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            self.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 16),
            
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoImageView.widthAnchor.constraint(equalToConstant: 90),
            photoImageView.heightAnchor.constraint(equalToConstant: 90),
            
            tickerLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 10),
            tickerLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -5),
            
            starButton.leadingAnchor.constraint(equalTo: tickerLabel.trailingAnchor, constant: 5),
            starButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -6),
    
            currentPriceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            currentPriceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -5),
            
            percentageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            percentageLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 20),
            
            deltaPriceLabel.trailingAnchor.constraint(equalTo: percentageLabel.leadingAnchor, constant: -3),
            deltaPriceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 20),
            
            nameLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -100),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 20),
        ])
    }
}
