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
    var models: [stockModel] = []
    
    var favouriteModels: [stockModel] = []
    
    init() {
        readJson()
    }
    func readJson() {
        if let path = Bundle.main.path(forResource: "stockProfiles", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                
                let models = try JSONDecoder().decode([jsonModel].self, from: data)
                
                for model in models {
                    self.models.append(stockModel(jsonModel: model))
                }
                
            } catch {
                print("Error: \(error)")
            }
        } else {
            print("JSON file not found")
        }
    }
    
    func getName(index: Int) -> String {
        return models[index].jsonModel.name
    }
    
    func getticker(index: Int) -> String {
        return models[index].jsonModel.ticker
    }
    
    func getState(index: Int) -> Bool {
        return models[index].isFavourite
    }
    
    func getNumberOfFavouriteCells() -> Int {
        var ans = 0
        for model in models {
            if model.isFavourite {
                ans = ans + 1
            }
        }
        return ans
    }
    
    func getFavouriteStocks() {
        favouriteModels.removeAll()
        for model in models {
            if model.isFavourite {
                favouriteModels.append(model)
            }
        }
    }
    
    func getImage(index: Int) -> String {
        return models[index].jsonModel.name
    }


}

