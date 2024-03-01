//
//  CoinTrendingViewModel.swift
//  SecondRecap
//
//  Created by Greed on 2/27/24.
//

import Foundation

final class CoinTrendingViewModel {
    
    let apiManager = APIManager.shared
    let repository = FavoriteRepository()

    var inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    var inputFavoriteListTrigger: Observable<Void?> = Observable(nil)
    
    var outputList: Observable<CoinTrending> = Observable(CoinTrending(coins: [], nfts: []))
    var outputFavoriteList: Observable<Array<CoinMarket>?> = Observable(nil)
    
    init() {
        inputViewDidLoadTrigger.bind { _ in
            self.requestCall()
        }
        inputFavoriteListTrigger.bind { _ in
            self.requestFavoriteCoinsCall()
        }
    }
    
    private func requestCall() {
        apiManager.callRequest(type: CoinTrending.self, api: .trending) { value in
            self.outputList.value = value
        }
    }
    
    private func requestFavoriteCoinsCall() {
        let favoriteItems = repository.fetchFavoriteItem()
        var tmpId = ""
        for item in favoriteItems {
            if item == favoriteItems.last {
                tmpId.append(item.id)
            } else {
                tmpId.append(item.id + ",")
            }
        }
        apiManager.callRequest(type: [CoinMarket].self, api: .coinInfo(id: tmpId)) { value in
            self.outputFavoriteList.value = value
        }
    }
    
}
