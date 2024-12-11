//
//  JSONReader.swift
//  StocksApp
//
//  Created by Dias Kaussov on 26.11.2024.
//
import UIKit

struct jsonModel: Codable {
    let name: String
    let imageUrl: String?
    let ticker: String
}

struct stockModel {
    var jsonModel: jsonModel
    var isFavourite = false
}

class JSONReader {
    var stockModels: [stockModel] = []
    
    var favouriteModels: [stockModel] = []
    
    var searchModels: [stockModel] = []

    
    init() {
        readJson()
    }
    
    func readJson() {
        if let path = Bundle.main.path(forResource: "stockProfiles", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                
                let models = try JSONDecoder().decode([jsonModel].self, from: data)
                
                for model in models {
                    self.stockModels.append(stockModel(jsonModel: model))
                }
                
            } catch {
                print("Error: \(error)")
            }
        } else {
            print("JSON file not found")
        }
    }
    
    func getModel(index: Int) -> stockModel {
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
        print("Model: \(newString)")
        print(newString.count)
        
        for i in 0..<20{
            let model = Array(self.stockModels[i].jsonModel.ticker)
            for j in 0..<newString.count {
                if newString[j] == model[j] {
                    self.searchModels.append(self.stockModels[i])
                }
            }
        }
    }
    
    func favouriteSelected(ticker: String?, state: Bool) {
        guard let ticker = ticker else { return }
        
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

