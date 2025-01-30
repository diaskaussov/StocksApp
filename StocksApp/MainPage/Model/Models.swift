//
//  CellModel.swift
//  StocksApp
//
//  Created by Dias Kaussov on 15.11.2024.
//

import UIKit

struct JsonModel: Codable, Hashable {
    let name: String
    let logo: String?
    let ticker: String
}

struct FinhubData: Codable {
    let c: Double // current price
    let d: Double // delta price
    let dp: Double // percentage
}

struct StockModel: Hashable {
    var jsonModel: JsonModel
    var image: UIImage? = nil
    var currentPrice: Double? = nil
    var deltaPrice: Double? = nil
    var percentage: Double? = nil
    var isFavourite = false
}
