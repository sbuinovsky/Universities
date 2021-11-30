//
//  University.swift
//  Universities
//
//  Created by Станислав Буйновский on 30.11.2021.
//

import Foundation

struct University: Codable {
    let country: String
    let webPages: [String]
    let name: String
    let domains: [String]
    
    enum CodingKeys: String, CodingKey {
        case country
        case webPages = "web_pages"
        case name, domains
    }
}
