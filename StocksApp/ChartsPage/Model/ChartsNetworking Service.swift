//
//  Networking Service.swift
//  StocksApp
//
//  Created by Dias Kaussov on 05.01.2025.
//

import UIKit

final class ChartsNetworkingService {
    func downloadPriceData(urlString: String, completion: @escaping (StockData?) -> Void) {
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

    
    func parseJson(priceData: Data) -> StockData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([String: StockTimeSeries].self, from: priceData)
            let stockEntries = decodedData.map { (date, timeSeries) in
                StockEntry(date: date, stockTimeSeries: timeSeries)
            }
            
            return StockData(dailyData: stockEntries)
        } catch {
            print("ChartsNetworkingService:, ParseJson: \(error)")
            return nil
        }
    }
}
