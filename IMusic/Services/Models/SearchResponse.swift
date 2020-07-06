//
//  SearchResponse.swift
//  IMusic
//
//  Created by Светлана Шардакова on 25.06.2020.
//  Copyright © 2020 Светлана Шардакова. All rights reserved.
//

import Foundation

struct SearchResponse: Decodable {
    var resultCount: Int
    var results: [Track]
}

struct Track: Decodable {
    var trackName: String
    var artistName: String
    var collectionName: String?
    var artworkUrl100: String?
    var previewUrl: String?
}
