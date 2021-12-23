//
//  QueryModel.swift
//  very_interesting_problem
//
//  Created by Khurshed Umarov on 18.12.2021.
//

import Foundation

/// Main structure for response
struct QueryModel: Codable {
    let imagesResults: [ImagesResult]

    enum CodingKeys: String, CodingKey {
        case imagesResults = "images_results"
    }
}

// MARK: - ImagesResult
struct ImagesResult: Codable {
    let position: Int
    let thumbnail: String
    let source, title: String
    let link: String
    let original: String
    let isProduct: Bool
    let inStock: Bool?

    enum CodingKeys: String, CodingKey {
        case position, thumbnail, source, title, link, original
        case isProduct = "is_product"
        case inStock = "in_stock"
    }
}
