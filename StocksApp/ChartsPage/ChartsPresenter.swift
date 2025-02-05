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
    private var stockData: StockModelDataDaily?
    private let stock: StockModel
    private let baseUrl = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&apikey=VXF5G7TO55GS43OD&outputsize=full&symbol="
    private let baseUrlDay = "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&apikey=KCLZJCGJX0ZOEUFB&interval=30min&symbol="
    private let chartNetworkingService = ChartsNetworkingService()
    
    var group = DispatchGroup()
    
    var chartData: [ChartDataEntry] = []
    
    var chartIntradayData: [ChartDataEntry] = []
    
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
        if numberOfDays == 1 {
            for i in 0...40 {
                a.append(chartIntradayData[chartIntradayData.count - i - 1])
            }
        } else {
            for i in 0...numberOfDays {
                a.append(chartData[chartData.count - i - 1])
            }
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
        group.enter()
        chartNetworkingService.downloadPriceData(urlString: url) { stockData in
            guard let stockData else { return }
            self.chartData = stockData.sortedByDate()
            self.group.leave()
        }
        chartNetworkingService.downloadIntradayData(urlString: dayUrl) { intradayData in
            guard let intradayData else { return }
            self.chartIntradayData = intradayData.sortedByDate()
        }
        group.notify(queue: .main) {
            print("ChartPresenter: entered group notify")
            self.chartPresenterDelegate?.drawChartLine()
        }
    }
    
    func getGradientFilling() -> CGGradient {
        let coloTop = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7).cgColor
        let colorBottom = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        let gradientColors = [coloTop, colorBottom] as CFArray
        let colorLocations: [CGFloat] = [1.0, 0.3]
        return CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)!
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
