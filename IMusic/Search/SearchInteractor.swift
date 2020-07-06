//
//  SearchInteractor.swift
//  IMusic
//
//  Created by Светлана Шардакова on 25.06.2020.
//  Copyright (c) 2020 Светлана Шардакова. All rights reserved.
//

import UIKit

protocol SearchBusinessLogic {
    func makeRequest(request: Search.Model.Request.RequestType)
}

class SearchInteractor: SearchBusinessLogic {
    
    var networkService = NetworkService()
    
    var presenter: SearchPresentationLogic?
    var service: SearchService?
    
    func makeRequest(request: Search.Model.Request.RequestType) {
        if service == nil {
            service = SearchService()
        }
        switch request {
        case .getTracks(let searchTerm):
            print("interactor .getTracks")
            presenter?.presentData(response: Search.Model.Response.ResponseType.presentFooterView)
            networkService.fetchTracks(searchText: searchTerm) { [weak self] (searchResponce) in
                self?.presenter?.presentData(response: Search.Model.Response.ResponseType.presentTracks(searchResponce: searchResponce))
            }
        }
    }
    
}
