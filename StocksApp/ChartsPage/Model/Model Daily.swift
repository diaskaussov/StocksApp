//
//  Model.swift
//  StocksApp
//
//  Created by Dias Kaussov on 04.01.2025.
//

import UIKit
import DGCharts

struct MetaDataDaily: Codable {
    let information: String
    let symbol: String
    let lastRefreshed: String
    
    enum CodingKeys: String, CodingKey {
        case information = "1. Information"
        case symbol = "2. Symbol"
        case lastRefreshed = "3. Last Refreshed"
    }
}

struct StockDailyInfo: Codable {
    let open: String
    let high: String
    let low: String
    let close: String
    let volume: String
    
    enum CodingKeys: String, CodingKey {
        case open = "1. open"
        case high = "2. high"
        case low = "3. low"
        case close = "4. close"
        case volume = "5. volume"
    }
}

struct StockDataDaily: Codable {
    let metaData: MetaDataDaily
    var timeSeriesDaily: [String: StockDailyInfo]
    
    enum CodingKeys: String, CodingKey {
        case metaData = "Meta Data"
        case timeSeriesDaily = "Time Series (Daily)"
    }
}

struct StockModelDataDaily {
    let metaData: MetaDataDaily
    var timeSeriesDaily: [Date: StockDailyInfo]
}

extension StockModelDataDaily {
    func sortedByDate() -> [ChartDataEntry] {
        let sortedData = timeSeriesDaily.sorted { $0.key < $1.key }
    
        let chartDataEntries = sortedData.compactMap { (date, dailyData) -> ChartDataEntry? in
        
            let xValue = date.timeIntervalSince1970
        
            guard let yValue = Double(dailyData.close) else {
                return nil
            }
            
            return ChartDataEntry(x: xValue, y: yValue)
        }
        return chartDataEntries
    }
}
