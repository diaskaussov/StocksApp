//
//  ChartsPresenter.swift
//  StocksApp
//
//  Created by Dias Kaussov on 27.12.2024.

import UIKit

final class ChartsPresenter {
    private let stock: StockModel
    private let baseUrl = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&apikey=VXF5G7TO55GS43OD&symbol="
    private let chartNetworkingService = ChartsNetworkingService()
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
    
    func getStockPrices() {
        let url = baseUrl + stock.jsonModel.ticker
        chartNetworkingService.downloadPriceData(urlString: url) { stockData in
            print("Hello")
            print(stockData)
            guard let stockData else { return }
            print("getStockModel: " + "\(stockData.dailyData[0].stockTimeSeries.close)")
        }
    }
}
