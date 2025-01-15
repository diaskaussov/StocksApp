//
//  Networking Service.swift
//  StocksApp
//
//  Created by Dias Kaussov on 05.01.2025.
//

import UIKit

final class ChartsNetworkingService {
    
    //1st API-key: KCLZJCGJX0ZOEUFB
    //2nd API-key: VXF5G7TO55GS43OD
    func downloadPriceData(urlString: String, completion: @escaping (StockData2?) -> Void) {
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

    
    func parseJson(priceData: Data?) -> StockData2? {
        if let jsonData = priceData{
            do {
                let stockData = try JSONDecoder().decode(StockData.self, from: jsonData)
                print("Symbol: \(stockData.metaData.symbol)")
                print("Last Refreshed: \(stockData.metaData.lastRefreshed)")
                var stockData2: StockData2 = StockData2(metaData: stockData.metaData, timeSeriesDaily: [:])
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
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Use POSIX locale for reliable parsing
        return dateFormatter.date(from: dateString)
    }
}
