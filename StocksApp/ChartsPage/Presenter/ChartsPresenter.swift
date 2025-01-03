//
//  ChartsPresenter.swift
//  StocksApp
//
//  Created by Dias Kaussov on 27.12.2024.

import UIKit

final class ChartsPresenter {
    private let stock: StockModel
    
    init(stock: StockModel) {
        self.stock = stock
    }
    
    func getStockTicker() -> String {
        return stock.jsonModel.ticker
    }
    
    func getStockName() -> String {
        return stock.jsonModel.name
    }
    
    func getStockState() -> Bool {
        return stock.isFavourite
    }
    
    func getStarButtonColor(sender: Bool) -> UIColor {
        if sender {
            return UIColor(
                red: 254.0/255.0,
                green: 190.0/255.0,
                blue: 0,
                alpha: 1
            )
        } else {
           return .gray
        }
    }
    
    func getCurrentPrice() -> Double {
        guard let currentPrice = stock.currentPrice else { return 0.0 }
        return currentPrice
    }
}
