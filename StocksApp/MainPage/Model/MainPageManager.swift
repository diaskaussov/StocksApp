//
//  JSONReader.swift
//  StocksApp
//
//  Created by Dias Kaussov on 26.11.2024.
//
import UIKit
import CoreData

protocol MainPageManagerDelegate {
    func reloadStocksTableView()
}

final class MainPageManager {
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private let networkingService = NetworkingService()
    
    private let baseUrl = "https://finnhub.io/api/v1/quote?token=ctekv9hr01qt478m7utgctekv9hr01qt478m7uu0&symbol="
    
    private var favouriteStocksCoreData = [Stock]()
    
    private var setOfStocks: Set<String> = []
    
    private var group = DispatchGroup()
    
    var stockModels: [StockModel] = []
    
    var numberOfStocksCoreData = 0
    
    var favouriteModels: [StockModel] = []
    
    var searchModels: [StockModel] = []
    
    var mainPageManagerDelegate: MainPageManagerDelegate?
    
    private var models: [JsonModel] = []
    
    init() {
        readFromCoreData()
        readJson()
        stockMakeNetworkRequests(0,20)
    }
    
    func readJson() {
        if let path = Bundle.main.path(forResource: "stockProfiles", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                
                models = try JSONDecoder().decode([JsonModel].self, from: data)
                
                models.sort(by: {$0.ticker < $1.ticker})
                
            } catch {
                print("ReadJson Error: \(error)")
            }
        } else {
            print("JSON file not found")
        }
    }
    
    func stockMakeNetworkRequests(_ lower: Int, _ upper: Int) {
        for index in lower...upper {
            group.enter()
            
            makeSingleNetworkRequest(
                imageUrl: models[index].logo,
                priceUrl: baseUrl + models[index].ticker,
                model: models[index]
            ) { stock in
                self.stockModels.append(stock)
                self.group.leave()
            }
            
            print("Finished single request: \(stockModels.count)")
            
            for index in 0..<stockModels.count {
                if setOfStocks.contains(stockModels[index].jsonModel.ticker) {
                    stockModels[index].isFavourite = true
                }
            }
        }
        
        group.notify(queue: .main) {
            self.mainPageManagerDelegate?.reloadStocksTableView()
        }
    }
    
    private func makeSingleNetworkRequest(
        imageUrl: String?,
        priceUrl: String,
        model: JsonModel,
        completion: @escaping (StockModel) -> Void
    ) {
        let miniGroup = DispatchGroup()
        
        var model = StockModel(jsonModel: model)
        
        miniGroup.enter()
        networkingService.downloadImage(urlString: imageUrl) { image in
            model.image = image
            miniGroup.leave()
        }
        
        miniGroup.enter()
        networkingService.downloadPriceData(urlString: priceUrl) { priceData in
            model.currentPrice = priceData?.c
            model.deltaPrice = priceData?.d
            model.percentage = priceData?.dp
            miniGroup.leave()
        }
        
        miniGroup.notify(queue: .main) {
            completion(model)
        }
    }
}


    /*
     1. makeSingleNetworkRequests reusable makeSingleNetworkRequests(price string, logo) -> StockModel
     2. makeNetworkRequestFavs(lower,upper) check out of bounds (all in init)
     3. favouriteModels logic not remove all but append
     4. getFavcellConfig(index) if null network call optimization check stockModel
     5. save favouriteModels to core data in the end of session
     */


//MARK: - CoreDataManager

extension MainPageManager {
    private func saveContext() {
        print("Entered saveContext")
        do {
            try context.save()
        } catch {
            print("Erorr with saving data to CoreData: \(error)")
        }
    }
    
    private func readFromCoreData() {
        let request: NSFetchRequest<Stock> = Stock.fetchRequest()
        do {
            favouriteStocksCoreData = try context.fetch(request)
            numberOfStocksCoreData = favouriteStocksCoreData.count
            if (numberOfStocksCoreData >= 20) {
                favsMakeNetworkRequests(0, 19)
                numberOfStocksCoreData -= 20
            } else if numberOfStocksCoreData > 0 {
                favsMakeNetworkRequests(0, numberOfStocksCoreData - 1)
                numberOfStocksCoreData = 0
            }
        } catch {
            print("Error with reading from CoreData: \(error)")
        }
    }
        
    func favsMakeNetworkRequests(_ lower: Int, _ upper: Int) {
        for index in lower...upper {
            group.enter()
            
            let ticker = favouriteStocksCoreData[index].ticker
            let name = favouriteStocksCoreData[index].name
            guard let ticker, let name else { return }
            
            let favModel = JsonModel(
                name: name,
                logo: favouriteStocksCoreData[index].logoUrl,
                ticker: ticker
            )
            
            makeSingleNetworkRequest(
                imageUrl: favouriteStocksCoreData[index].logoUrl,
                priceUrl: baseUrl + ticker,
                model: favModel
            ) { stock in
                self.setOfStocks.insert(stock.jsonModel.ticker)
                self.favouriteModels.append(stock)
                self.favouriteModels[self.favouriteModels.count - 1].isFavourite = true
                self.group.leave()
            }
        }
    }
}

//MARK: - StocksTableViewManager

extension MainPageManager {
    func getModel(index: Int) -> StockModel {
        return stockModels[index]
    }
    
    func getNumberOfSearchingCells() -> Int {
        return searchModels.count
    }
    
    func removeSearchModel() {
        searchModels.removeAll()
    }
    
    func getNumberOfFavouriteStocks() -> Int {
        return favouriteStocksCoreData.count
    }
    
    func favouriteSelected(ticker: String?, state: Bool) {
        guard let ticker else { return }
        
        print("Entered favouriteSelected with ticker: \(ticker) and state: \(state)")
        
        for i in 0...stockModels.count {
            if stockModels[i].jsonModel.ticker == ticker {
                
                stockModels[i].isFavourite = state

                if state {
                    favouriteModels.append(stockModels[i])
                } else {
                    for index in 0..<favouriteModels.count {
                        if favouriteModels[index].jsonModel.ticker == ticker {
                            favouriteModels.remove(at: index)
                            break
                        }
                    }
                }
                break
            }
        }
    }
    
    func findSearchStocks(newString: [Character]) {
        searchModels.removeAll()
        
        for i in 0..<stockModels.count {
            let ticker = Array(self.stockModels[i].jsonModel.ticker.lowercased())
            let name = Array(self.stockModels[i].jsonModel.name.lowercased())
            
            let flagTicker = compareTwoStrings(newString: newString, compareString: ticker)
            let flagName = compareTwoStrings(newString: newString, compareString: name)
            
            if flagTicker || flagName {
                searchModels.append(self.stockModels[i])
            }
        }
    }
    
    private func compareTwoStrings(newString: [Character], compareString: [Character]) -> Bool {
        var flag = true
        let minLength = min(newString.count, compareString.count)
        for j in 0..<minLength {
            if newString[j] != compareString[j] {
                flag = false
                break
            }
        }
        return flag
    }
}

/*
 number = 3
 stockModel = [1, 2, 3]
 
 */
