//
//  NetworkingService.swift
//  StocksApp
//
//  Created by Dias Kaussov on 11.12.2024.
//

import UIKit

final class NetworkingService {
    private let apiKey = "ctekv9hr01qt478m7utgctekv9hr01qt478m7uu0" // unused variable
    private let secret = "ctekv9hr01qt478m7uv0" // unused variable
    
    func downloadImage(
        urlString: String?,
        completion: @escaping (_ image: UIImage?) -> ()
    ) {
        
        guard let saveString = urlString, let url = URL(string: saveString) else {
            print("NetworkService Wrong URL")
            completion(UIImage(systemName: "x.square.fill"))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error {
                print("NetworkingService, Error in downloading image: \(error)")
                completion(UIImage(systemName: "x.square.fill"))
                return
            }
            
            guard let data = data else { return }
            
            if let image = UIImage(data: data) {
                completion(image)
                return
            }
            completion(UIImage(systemName: "x.square.fill"))
        }.resume()
    }
    
    private let errorData = FinhubData(c: 0.0, d: 0.0, dp: 0.0)
    
    func downloadPriceData(urlString: String, completion: @escaping (FinhubData?) -> Void) {
        
        guard let url = URL(string: urlString) else {
            completion(errorData)
            return
        }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { [self] (data, response, error) in
            if let error = error {
                print("NetworkingService, Error fetching data: \(error)")
                completion(errorData)
                return
            }
            
            guard let safeData = data else {
                print("NetworkingService, No data received.")
                completion(errorData)
                return
            }
            
            guard let parsedData = self.parseJson(priceData: safeData) else {
                print("NetworkingService, Error parsing data.")
                completion(errorData)
                return
            }
            
            let finData = FinhubData(c: parsedData.c, d: parsedData.d, dp: parsedData.dp)
            completion(finData)
        }
        task.resume()
    }

    
    func parseJson(priceData: Data) -> FinhubData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(FinhubData.self, from: priceData)
            let currentPrice = decodedData.c
            let deltaPrice = decodedData.d
            let percentage = decodedData.dp
            let finhubModel = FinhubData(c: currentPrice, d: deltaPrice, dp: percentage)
            return finhubModel
        } catch {
            print("NetworkgingService, ParseJsonError: \(error)")
            return nil
        }
    }
}
