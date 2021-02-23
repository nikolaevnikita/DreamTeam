//
//  Hero.swift
//  DreamTeam
//
//  Created by Николаев Никита on 20.02.2021.
//

import Foundation

struct HeroResponse: Decodable {
    let id: Int
    let name: String
    let img: String
    
    enum CodingKeys: String, CodingKey {
        case id = "char_id"
        case name
        case img
    }
}
