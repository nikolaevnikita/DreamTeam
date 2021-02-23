//
//  QuoteResponse.swift
//  DreamTeam
//
//  Created by Николаев Никита on 21.02.2021.
//

import Foundation

struct QuoteResponse: Decodable {
    let id: Int
    let quote: String
    
    enum CodingKeys: String, CodingKey {
        case id = "quote_id"
        case quote
    }
}
