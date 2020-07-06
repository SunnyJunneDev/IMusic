//
//  NetworkService.swift
//  IMusic
//
//  Created by Светлана Шардакова on 25.06.2020.
//  Copyright © 2020 Светлана Шардакова. All rights reserved.
//

import UIKit
import Alamofire

class NetworkService {
    
    func fetchTracks(searchText: String, completion: @escaping ((SearchResponse)?) -> Void) {
        
        let url = "https://itunes.apple.com/search"
        let parameters = ["term":"\(searchText)",
                         "limit":"20",
                         "media":"music"]
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil ).responseData { (dataResponse) in
            if let error = dataResponse.error {
                print("Error received requesting data: \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let data = dataResponse.data else { return }
            
            let decoder = JSONDecoder()
            do {
                let objects = try decoder.decode(SearchResponse.self, from: data)
                print("objects: ", objects)
                completion(objects)
                
            } catch let error {
                print("Failed to decode JSON", error)
                completion(nil)
            }
//            let someString = String(data: data, encoding: .utf8)
//            print(someString ?? "")
        }
    }
}
