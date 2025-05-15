//
//  DetailResponse.swift
//  Movie App 2
//
//  Created by Gülhan Büşra TOSUN on 9.05.2025.
//

import Foundation

struct MovieDetail: Codable {
    let id: Int?
    let originalTitle: String?
    let posterPath: String?
    let releaseDate: String?
    let voteCount: Int?
    let overview: String?
    let homepage: String?

    enum CodingKeys: String, CodingKey {
        case id
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteCount = "vote_count"
        case overview
        case homepage
    }
}
