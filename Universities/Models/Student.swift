//
//  Student.swift
//  Universities
//
//  Created by Станислав Буйновский on 30.11.2021.
//

import Foundation

struct Student {
    let gender: String
    let name: Name
    let location: Location
    let email: String
    let phone: String
    let picture: Picture
    
    var description: String {
        """
        Gender: \(gender)
        email: \(email)
        phone: \(phone)
        location: \(location.description)
        """
    }
}

struct Name {
    let title: String
    let first: String
    let last: String
    
    var fullName: String {
        "\(first) \(last)"
    }
}

struct Location {
    let city: String
    let street: String
    let country: String
    let postcode: Int
    
    var description: String {
        "\(country), \(postcode), \(city) \(street)"
    }
}

struct Picture {
    let large: String
    let medium: String
    let thumbnail: String
}


