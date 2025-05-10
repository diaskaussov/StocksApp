//
//  Model Intraday.swift
//  StocksApp
//
//  Created by Dias Kaussov on 17.01.2025.
//

import Foundation
import DGCharts

struct MetaDataIntraday: Decodable {
    let information: String
    let symbol: String
    let lastRefreshed: String
    let interval: String
    
    enum CodingKeys: String, CodingKey {
        case information = "1. Information"
        case symbol = "2. Symbol"
        case lastRefreshed = "3. Last Refreshed"
        case interval = "4. Interval"
    }
}

struct StockIntradayInfo: Decodable {
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

struct StockDataIntraday: Decodable {
    let metaData: MetaDataDaily
    let timeSeries: [String: StockIntradayInfo]
    
    enum CodingKeys: String, CodingKey {
        case metaData = "Meta Data"
        case timeSeries = "Time Series (30min)"
    }
}

struct StockModelDataIntraday {
    let metaData: MetaDataDaily
    var timeSeriesIntraday: [Date: StockIntradayInfo]
}

extension StockModelDataIntraday {
    func sortedByDate() -> [ChartDataEntry] {
        let sortedData = timeSeriesIntraday.sorted { $0.key < $1.key }
        
        let chartDataEntries = sortedData.compactMap { (date, intradayData) -> ChartDataEntry? in

            let xValue = date.timeIntervalSince1970
            
            guard let yValue = Double(intradayData.close) else {
                return nil
            }
            
            return ChartDataEntry(x: xValue, y: yValue)
        }
        return chartDataEntries
    }
}
