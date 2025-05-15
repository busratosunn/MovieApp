//
//  ContentModel.swift
//  Movie App
//
//  Created by Gülhan Büşra TOSUN on 15.05.2025.
//

import Foundation
import UIKit

struct CategoryModel {
    let text: String
    let contents: [ContentModel]
    
    init(text: String, contents: [ContentModel]) {
        self.text = text
        self.contents = contents
    }
}
struct ContentList: Codable {
    let contents: [ContentModel]
}
struct ContentModel: Codable {
    let imageName: String
    let category: String
    let title: String
    let duration: String
    let imdbScore: String
    let actors: [String]
    let imdbID: String
}

extension ContentModel {
    var imdbURL: String? {
        return "https://www.imdb.com/title/\(imdbID)/"
    }
}
