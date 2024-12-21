//
//  NetworkingService.swift
//  StocksApp
//
//  Created by Dias Kaussov on 11.12.2024.
//

import UIKit

class NetworkingService {
    
    //Finhub API Key: ctekv9hr01qt478m7utgctekv9hr01qt478m7uu0
    //Secret: ctekv9hr01qt478m7uv0
    
    func downloadImage(
        urlString: String,
        completion: @escaping (_ image: UIImage?) -> ()
    ) {
        guard let url = URL(string: urlString) else {
            print("NetworkService Wrong URL: \(urlString)")
            completion(UIImage(systemName: "x.square.fill"))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error {
                print("Error in downloading image: \(error)")
                completion(UIImage(systemName: "x.square.fill"))
                return
            }
            
            guard let data = data else { return }
            
            if let image = UIImage(data: data) {
                print("Got UIImage")
                completion(image)
                return
            }
            print("Cannot get UIImage (NetworkService)")
        }.resume()
    }
    
    func downloadPriceData(urlString: String, completion: @escaping (finhubData?) -> Void) {
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching data: \(error)")
                completion(nil)
                return
            }
            
            guard let safeData = data else {
                print("No data received.")
                completion(nil)
                return
            }
            
            guard let parsedData = self.parseJson(priceData: safeData) else {
                print("Error parsing data.")
                completion(nil)
                return
            }
            
            let finData = finhubData(c: parsedData.c, d: parsedData.d, dp: parsedData.dp)
            completion(finData)
        }
        task.resume()
    }

    
    func parseJson(priceData: Data) -> finhubData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(finhubData.self, from: priceData)
            let currentPrice = decodedData.c
            let deltaPrice = decodedData.d
            let percentage = decodedData.dp
            let finhubModel = finhubData(c: currentPrice, d: deltaPrice, dp: percentage)
            return finhubModel
        } catch {
            print("NetworkgingService, ParseJson: \(error)")
            return nil
        }
    }
}
