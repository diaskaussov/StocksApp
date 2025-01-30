//
//  Networking Service.swift
//  StocksApp
//
//  Created by Dias Kaussov on 05.01.2025.
//

import UIKit

//MARK: - Daily Api Network Call

final class ChartsNetworkingService {
    private let apiKey1 = "KCLZJCGJX0ZOEUFB"
    
    private let apiKey2 = "VXF5G7TO55GS43OD"
    
    func downloadPriceData(urlString: String, completion: @escaping (StockModelDataDaily?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("ChartsNetworkingService: Error fetching data: \(error)")
                completion(nil)
                return
            }
            
            guard let safeData = data else {
                print("ChartsNetworkingService: No data received.")
                completion(nil)
                return
            }
            
            guard let parsedData = self.parseJson(priceData: safeData) else {
                print("ChartsNetworkingService: Error parsing data.")
                completion(nil)
                return
            }
            completion(parsedData)
        }
        task.resume()
    }

    
    func parseJson(priceData: Data?) -> StockModelDataDaily? {
        if let jsonData = priceData{
            do {
                let stockData = try JSONDecoder().decode(StockDataDaily.self, from: jsonData)
                print("Symbol: \(stockData.metaData.symbol)")
                print("Last Refreshed: \(stockData.metaData.lastRefreshed)")
                var stockData2: StockModelDataDaily = StockModelDataDaily(metaData: stockData.metaData, timeSeriesDaily: [:])
                for (date, value) in stockData.timeSeriesDaily {
                    stockData2.timeSeriesDaily[stringToDate(date) ?? Date()] = value
                }
                return stockData2
            } catch {
                print("ChartsNetworkingService: Error decoding JSON: \(error)")
            }
        }
        return nil
    }
    
    func stringToDate(_ dateString: String, format: String = "yyyy-MM-dd") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.date(from: dateString)
    }
}

//MARK: - Intraday Api Network Call

extension ChartsNetworkingService {
    func downloadIntradayData(urlString: String, completion: @escaping (StockModelDataIntraday?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("ChartsNetworkingService, Intraday: Error fetching data: \(error)")
                completion(nil)
                return
            }
            
            guard let safeData = data else {
                print("ChartsNetworkingService, Intraday: No data received.")
                completion(nil)
                return
            }
            
            guard let parsedData = self.parseJson(intradayData: safeData) else {
                print("ChartsNetworkingService, Intraday: Error parsing data.")
                completion(nil)
                return
            }
            completion(parsedData)
        }
        task.resume()
    }
    
    func parseJson(intradayData: Data?) -> StockModelDataIntraday? {
        if let jsonData = intradayData {
            do {
                let intradayData = try JSONDecoder().decode(StockDataIntraday.self, from: jsonData)
                print("Symbol: \(intradayData.metaData.symbol)")
                print("Last Refreshed: \(intradayData.metaData.lastRefreshed)")
                
                var stockIntradayData = StockModelDataIntraday(metaData: intradayData.metaData, timeSeriesIntraday: [:])
                for (date, value) in intradayData.timeSeries {
                    stockIntradayData.timeSeriesIntraday[stringToDateIntraday(date) ?? Date()] = value
                }
                return stockIntradayData
            } catch {
                print("ChartsNetworkingService, Intraday: Error decoding JSON: \(error)")
            }
        }
        return nil
    }
    
    func stringToDateIntraday(_ dateString: String, format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Use POSIX locale for reliable parsing
        return dateFormatter.date(from: dateString)
    }
}
