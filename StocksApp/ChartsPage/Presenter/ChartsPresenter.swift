//
//  ChartsPresenter.swift
//  StocksApp
//
//  Created by Dias Kaussov on 27.12.2024.

import UIKit
import DGCharts

protocol ChartsPresenterDelegate {
    func drawChartLine()
}

final class ChartsPresenter {
    var chartPresenterDelegate: ChartsPresenterDelegate?
    private var stockData: StockData2?
    private let stock: StockModel
    private let baseUrl = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&apikey=KCLZJCGJX0ZOEUFB&outputsize=full&symbol="
    private let baseUrlDay = "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&apikey=VXF5G7TO55GS43OD&interval=30min&symbol="
    private let chartNetworkingService = ChartsNetworkingService()
    
    var chartData: [ChartDataEntry] = []

    
    init(stock: StockModel) {
        self.stock = stock
        getStockPrices()
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
    
    func getStockData(numberOfDays: Int) -> [ChartDataEntry] {
        var a: [ChartDataEntry] = []
        if numberOfDays >= chartData.count {
            return chartData
        }
        for i in 0...numberOfDays {
            a.append(chartData[i])
        }
        return a.reversed()
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
        let dayUrl = baseUrlDay + stock.jsonModel.ticker
        chartNetworkingService.downloadPriceData(urlString: url) { stockData in
            guard let stockData else { return }
            self.chartData = stockData.sortedByDate()
            self.chartPresenterDelegate?.drawChartLine()
        }
    }
}

/*
 To do:
 1. didSet
    i. Call delegate
    ii. Return Data
 2. Show data in chart
 3. Add button functionality
 4. Intradayli networkingService
 
 */
