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
    
    var favouriteModels: [StockModel] = []
    
    var searchModels: [StockModel] = []
    
    var mainPageManagerDelegate: MainPageManagerDelegate?
    
    private var models: [JsonModel] = []
    
    init() {
        let dataFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(dataFile)
        readFromCoreData()
        readJson()
        stockMakeNetworkRequests(0,19)
    }
    
    private func readJson() {
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
            if isDuplicate(models[index].ticker) {
                continue
            }
            
            group.enter()
            
            makeSingleNetworkRequest(model: models[index]) { stock in
                self.stockModels.append(stock)
                self.group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.mainPageManagerDelegate?.reloadStocksTableView()
        }
    }

    private func isDuplicate(_ ticker: String) -> Bool {
        for index in 0..<favouriteStocksCoreData.count {
            if favouriteStocksCoreData[index].ticker == ticker {
                return true
            }
        }
        return false
    }
    
    private func makeSingleNetworkRequest(
        model: JsonModel,
        completion: @escaping (StockModel) -> Void
    ) {
        let miniGroup = DispatchGroup()
        
        let priceUrl = baseUrl + model.ticker
        
        var model = StockModel(jsonModel: model)
        
        miniGroup.enter()
        networkingService.downloadImage(urlString: model.jsonModel.logo) { image in
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

//MARK: - CoreDataManager

extension MainPageManager {
    func saveContext() {
        for stock in favouriteStocksCoreData {
            context.delete(stock)
        }
        for model in favouriteModels {
            let newStock = Stock(context: context)
            newStock.isFavourite = model.isFavourite
            newStock.ticker = model.jsonModel.ticker
            newStock.name = model.jsonModel.name
            newStock.logoUrl = model.jsonModel.logo
            favouriteStocksCoreData.append(newStock)
        }
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
            downloadFromCoreData()
        } catch {
            print("Error with reading from CoreData: \(error)")
        }
    }
        
    private func downloadFromCoreData() {
        for model in favouriteStocksCoreData {
            guard let name = model.name, let ticker = model.ticker else { return }
                
            let newJsonModel = JsonModel(name: name, logo: model.logoUrl, ticker: ticker)
            
            makeSingleNetworkRequest(model: newJsonModel) { stock in
                var newStock = stock
                newStock.isFavourite = true
                self.stockModels.append(newStock)
                self.favouriteModels.append(newStock)
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
        return favouriteModels.count
    }
    
    func favouriteSelected(ticker: String?, state: Bool) {
        guard let ticker else { return }
        
        print("Entered favouriteSelected with ticker: \(ticker) and state: \(state)")
        
        for i in 0..<stockModels.count {
            if stockModels[i].jsonModel.ticker == ticker {
                stockModels[i].isFavourite = state

                if state {
                    favouriteModels.append(stockModels[i])
                } else {
                    removeFromFavouritesStock(with: ticker)
                }
            }
        }
    }
    
    private func removeFromFavouritesStock(with ticker: String) {
        for index in 0..<favouriteModels.count {
            if favouriteModels[index].jsonModel.ticker == ticker {
                favouriteModels.remove(at: index)
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
    
    1. favouriteStocksCoreData используем в начале для загрузки из корДата
        1.1 Загружаем первые 20 ссылок из жсон листа и делаем нетворкинг запрос
    2. делаем нетворкинг запрос для ВСЕХ тикеров из favouriteStocksCoreData и аппендим в stockModels
 
        получается в этом моменте у нас есть stockModels которое состоит из первых 20 тикеров из жсонки
    и все тикеры из кордаты с параметром isFav тру. Здесь забей хоть 40 или 400 тикеров загружаем все
    
    3. Здесь уже на твое усмотрение как делать логику показывание фавСтоксов. можно филтер stockModels сделать
    как вариант и сохрянять в favouriteModels и оттуда брать индексы. возможно Вью контроллер тоже надо будет поменять
    Можно будет взять старую имплементацию
    
    4. теперь деламе сохронение на кор дату. Делаем фильтр stockModels и обновляем переменную favouriteStocksCoreData
    и после этого делаем сейвКонтекст
 
    и все теперь все должно работать
 */
