//
//  Pokemon.swift
//  Pokemon
//
//  Created by Crunchie on 30/08/17.
//  Copyright © 2017 Luke Job. All rights reserved.
//

import Foundation

struct Pokemon: Codable {
    
    let name: String
    let height: Int?
    let weight: Int?
    let url: URL?
    let sprites: Sprites?
    
    struct Sprites: Codable {
        let imageUrl: URL?
        private enum CodingKeys : String, CodingKey{
            case imageUrl = "front_default"
        }
    }

    
}
