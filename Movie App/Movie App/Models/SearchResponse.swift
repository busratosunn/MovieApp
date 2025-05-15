//
//  SearchResponse.swift
//  Movie App 2
//
//  Created by Gülhan Büşra TOSUN on 12.05.2025.
//

import Foundation

struct SearchResponse: Codable {
    let results: [SearchMovie]
}

struct SearchMovie: Codable {
    let posterPath: String?
    let originalTitle: String?
    
    
    enum CodingKeys: String,CodingKey {
        case posterPath = "poster_path"
        case originalTitle = "original_title"
    }
}
