//
//  JSONReader.swift
//  StocksApp
//
//  Created by Dias Kaussov on 26.11.2024.
//
import UIKit

protocol JSONReaderDelegate {
    func reloadStocksTableView()
}

final class JSONReader {
    var stockModels: [StockModel] = []
    
    var favouriteModels: [StockModel] = []
    
    var searchModels: [StockModel] = []
    
    var delegate: JSONReaderDelegate?
    
    let networkingService = NetworkingService()
    
    private let baseUrl = "https://finnhub.io/api/v1/quote?token=ctekv9hr01qt478m7utgctekv9hr01qt478m7uu0&symbol="
    
    init() {
        readJson()
    }
    
    var group = DispatchGroup()
    
    func readJson() {
        if let path = Bundle.main.path(forResource: "stockProfiles", ofType: "json") {
            do {
                
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                
                let models = try JSONDecoder().decode([jsonModel].self, from: data)
                
                for model in 0...20 {
                    self.stockModels.append(StockModel(jsonModel: models[model]))
                    group.enter()
                    networkingService.downloadImage(urlString: stockModels[model].jsonModel.logo) { image in
                        self.stockModels[model].image = image
                        self.group.leave()
                    }
                    
                    let url = baseUrl + stockModels[model].jsonModel.ticker
                    
                    networkingService.downloadPriceData(urlString: url) { [self] priceData in
                        stockModels[model].currentPrice = priceData?.c
                        stockModels[model].deltaPrice = priceData?.d
                        stockModels[model].percentage = priceData?.dp
                    }
                }
                
            } catch {
                print("Error: \(error)")
            }
        } else {
            print("JSON file not found")
        }
        group.notify(queue: .main) {
            print("Entered group notify")
            self.delegate?.reloadStocksTableView()
        }
    }
    
    func getModel(index: Int) -> StockModel {
        return stockModels[index]
    }
    
    func getNumberOfFavouriteCells() -> Int {
        var ans = 0
        for model in stockModels {
            if model.isFavourite {
                ans = ans + 1
            }
        }
        return ans
    }
    
    func getNumberOfSearchingCells() -> Int {
        return searchModels.count
    }
    
    func findFavouriteStocks() {
        favouriteModels.removeAll()
        for model in stockModels {
            if model.isFavourite {
                favouriteModels.append(model)
            }
        }
    }
    
    func findSearchStocks(newString: [Character]) {
        searchModels.removeAll()

        for i in 0..<20{
            let model = Array(self.stockModels[i].jsonModel.ticker)
            var flag = true
            let length = newString.count < model.count ? newString.count : model.count
                        
            for j in 0..<length {
                if newString[j] != model[j] {
                    flag = false
                }
            }
            
            if flag {
                searchModels.append(self.stockModels[i])
            }
        }
    }
    
    func favouriteSelected(ticker: String?, state: Bool) {
        guard let ticker else { return }
        
        print("Entered favouriteSelected with ticker: \(ticker) and state: \(state)")
        
        for i in 0...stockModels.count {
            if stockModels[i].jsonModel.ticker == ticker {
                stockModels[i].isFavourite = state
                break
            }
        }
    }
    
    func removeSearchModel() {
        searchModels.removeAll()
    }
}

