//
//  Model.swift
//  StocksApp
//
//  Created by Dias Kaussov on 04.01.2025.
//

import UIKit

struct StockData {
    let dailyData: [StockEntry]
}

struct StockEntry: Codable {
    let date: String
    let stockTimeSeries: StockTimeSeries
    
    enum Coding: String, CodingKey {
        case stockTimeSeries = "Time Series (Daily)"
    }
}

struct StockTimeSeries: Codable {
    let close: String
    
    enum CodingKeys: String, CodingKey {
        case close = "4. close"
    }
}

