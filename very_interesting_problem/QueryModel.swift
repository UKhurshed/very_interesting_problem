//
//  QueryModel.swift
//  very_interesting_problem
//
//  Created by Khurshed Umarov on 18.12.2021.
//

import Foundation

struct QueryModel: Codable {
    let searchMetadata: SearchMetadata
    let searchInformation: SearchInformation
    let shoppingResults: [ShoppingResult]
    let suggestedSearches: [SuggestedSearch]
    let imagesResults: [ImagesResult]

    enum CodingKeys: String, CodingKey {
        case searchMetadata = "search_metadata"
        case searchInformation = "search_information"
        case shoppingResults = "shopping_results"
        case suggestedSearches = "suggested_searches"
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

// MARK: - SearchInformation
struct SearchInformation: Codable {
    let imageResultsState, queryDisplayed: String

    enum CodingKeys: String, CodingKey {
        case imageResultsState = "image_results_state"
        case queryDisplayed = "query_displayed"
    }
}

// MARK: - SearchMetadata
struct SearchMetadata: Codable {
    let id, status: String
    let jsonEndpoint: String
    let createdAt, processedAt: String
    let googleURL: String
    let rawHTMLFile: String
    let totalTimeTaken: Double

    enum CodingKeys: String, CodingKey {
        case id, status
        case jsonEndpoint = "json_endpoint"
        case createdAt = "created_at"
        case processedAt = "processed_at"
        case googleURL = "google_url"
        case rawHTMLFile = "raw_html_file"
        case totalTimeTaken = "total_time_taken"
    }
}


// MARK: - ShoppingResult
struct ShoppingResult: Codable {
    let position: Int
    let link: String
}

// MARK: - SuggestedSearch
struct SuggestedSearch: Codable {
    let name: String
    let link: String
    let chips: String
    let serpapiLink: String
    let thumbnail: String

    enum CodingKeys: String, CodingKey {
        case name, link, chips
        case serpapiLink = "serpapi_link"
        case thumbnail
    }
}
