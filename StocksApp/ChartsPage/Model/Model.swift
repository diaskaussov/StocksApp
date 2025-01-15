//
//  Model.swift
//  StocksApp
//
//  Created by Dias Kaussov on 04.01.2025.
//

import UIKit
import DGCharts

struct StockData2 {
    let metaData: MetaData
    var timeSeriesDaily: [Date: DailyData]
}

extension StockData2 {
    func sortedByDate() -> [ChartDataEntry] {
        // Step 1: Sort the timeSeriesDaily dictionary by key (date)
        let sortedData = timeSeriesDaily.sorted { $0.key < $1.key }
        
        // Step 2: Map the sorted data into ChartDataEntry objects
        let chartDataEntries = sortedData.compactMap { (date, dailyData) -> ChartDataEntry? in
            // Convert the date to a time interval for the x-value
            let xValue = date.timeIntervalSince1970
            
            // Convert the close value to a Double for the y-value
            guard let yValue = Double(dailyData.close) else {
                return nil // Skip if the close value is not a valid number
            }
            
            // Create and return a ChartDataEntry
            return ChartDataEntry(x: xValue, y: yValue)
        }
        
        return chartDataEntries
    }
}


struct StockData: Codable {
    let metaData: MetaData
    var timeSeriesDaily: [String: DailyData]
    
    enum CodingKeys: String, CodingKey {
        case metaData = "Meta Data"
        case timeSeriesDaily = "Time Series (Daily)"
    }
}

struct MetaData: Codable {
    let information: String
    let symbol: String
    let lastRefreshed: String
    
    enum CodingKeys: String, CodingKey {
        case information = "1. Information"
        case symbol = "2. Symbol"
        case lastRefreshed = "3. Last Refreshed"
    }
}

struct DailyData: Codable {
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
