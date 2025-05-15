//
//  Genre.swift
//  Movie App 2
//
//  Created by Gülhan Büşra TOSUN on 7.05.2025.
//

import Foundation

struct Category: Codable {
    let id: Int?
    let name: String?
}

struct CategoriesResponse: Codable {
    let genres: [Category]?
}
