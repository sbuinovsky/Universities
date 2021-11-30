//
//  NetworkManager.swift
//  Universities
//
//  Created by Станислав Буйновский on 30.11.2021.
//

import Foundation
import Alamofire

enum Link: String {
    case universities = "http://universities.hipolabs.com/search?country="
    case logo = "https://logo.clearbit.com/"
    case student = "https://randomuser.me/api/"
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

class NetworkManager {
    
    static let share = NetworkManager()
    
    private init() {}
    
    func fetchUniversities(for country: String, completion: @escaping(Result<[University], NetworkError>) -> Void) {
        let apiPath = Link.universities.rawValue + country
        
        AF.request(apiPath)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    let universities = self.parseUniversities(with: value)
                    completion(.success(universities))
                case .failure:
                    completion(.failure(.decodingError))
                }
            }
    }
    
    func fetchStudent(completion: @escaping(Result<Student, NetworkError>) -> Void) {
        let apiPath = Link.student.rawValue
        
        AF.request(apiPath)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    guard let student = self.parseStudent(with: value) else { return }
                    completion(.success(student))
                case .failure:
                    completion(.failure(.decodingError))
                }
            }
    }
    
    private func parseUniversities(with value: (Any)) -> [University] {
        guard let universitiesData = value as? [[String: Any]] else { return []}
        
        var universities: [University] = []
        
        for item in universitiesData {
            
            let university = University(
                country: item["country"] as? String ?? "",
                webPages: item["web_pages"] as? [String] ?? [],
                name: item["name"] as? String ?? "",
                domains: item["domains"] as? [String] ?? [])
            
            universities.append(university)
        }
        
        return universities
    }
    
    private func parseStudent(with value: (Any)) -> Student? {
        guard let studentData = value as? [String: Any] else { return nil }
        guard let resultsBlock = studentData["results"] as? [(Any)] else { return nil}
        guard let results = resultsBlock.first as? [String: Any] else { return nil}
        
        let gender = results["gender"] as! String
        let nameBlock = results["name"] as! [String: String]
        let name = Name(
            title: nameBlock["title"] ?? "",
            first: nameBlock["first"] ?? "",
            last: nameBlock["last"] ?? "")
        let locationBlock = results["location"] as? [String: Any] ?? [:]
        let streetBlock = locationBlock["street"] as? [String: Any] ?? [:]
        let location = Location(
            city: locationBlock["city"] as? String ?? "",
            street: streetBlock["name"] as? String ?? "",
            country: locationBlock["country"] as? String ?? "",
            postcode: locationBlock["postcode"] as? Int ?? 0)
        let email = results["email"] as? String ?? ""
        let phone = results["phone"] as? String ?? ""
        let pictureBlock = results["picture"] as? [String: String] ?? [:]
        let picture = Picture(
            large: pictureBlock["large"] ?? "",
            medium: pictureBlock["medium"] ?? "",
            thumbnail: pictureBlock["thumbnail"] ?? "")
        
        return Student(
            gender: gender,
            name: name,
            location: location,
            email: email,
            phone: phone,
            picture: picture)
    }
}


class ImageManager {
    static var shared = ImageManager()
    
    private init() {}
    
    func fetchLogo(for domain: String?) -> Data? {
        guard let domainName = domain else { return nil }
        let apiPath = Link.logo.rawValue + domainName
        guard let imageURL = URL(string: apiPath) else { return nil }
        return try? Data(contentsOf: imageURL)
    }
    
    func fetchPhoto(for urlPath: String?) -> Data? {
        guard let urlPath = urlPath else { return nil }
        guard let imageURL = URL(string: urlPath) else { return nil }
        return try? Data(contentsOf: imageURL)
    }
}
