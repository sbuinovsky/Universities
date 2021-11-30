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
                    guard let universitiesData = value as? [[String: Any]] else { return }
                    
                    var universities: [University] = []
                    
                    for item in universitiesData {
                        
                        let university = University(
                            country: item["country"] as! String,
                            webPages: item["web_pages"] as! [String],
                            name: item["name"] as! String,
                            domains: item["domains"] as! [String])
                        
                        universities.append(university)
                    }
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
                    guard let studentData = value as? [String: Any] else { return }
                    guard let resultsBlock = studentData["results"] as? [(Any)] else { return }
                    guard let results = resultsBlock.first as? [String: Any] else { return }
                    
                    let gender = results["gender"] as! String
                    let nameBlock = results["name"] as! [String: String]
                    let name = Name(
                        title: nameBlock["title"] ?? "",
                        first: nameBlock["first"] ?? "",
                        last: nameBlock["last"] ?? "")
                    let locationBlock = results["location"] as! [String: Any]
                    let streetBlock = locationBlock["street"] as! [String: Any]
                    let location = Location(
                        city: locationBlock["city"] as! String,
                        street: streetBlock["name"] as! String,
                        country: locationBlock["country"] as! String,
                        postcode: locationBlock["postcode"] as? Int ?? 0)
                    let email = results["email"] as! String
                    let phone = results["phone"] as! String
                    let pictureBlock = results["picture"] as! [String: String]
                    let picture = Picture(
                        large: pictureBlock["large"] ?? "",
                        medium: pictureBlock["medium"] ?? "",
                        thumbnail: pictureBlock["thumbnail"] ?? "")
                   
                    let student = Student(
                        gender: gender,
                        name: name,
                        location: location,
                        email: email,
                        phone: phone,
                        picture: picture)
                    
                    completion(.success(student))
                case .failure:
                    completion(.failure(.decodingError))
                }
            }
    }
    
    func fetchStudents(completion: @escaping(Result<[Student], NetworkError>) -> Void) {
        let studentsCount = Int.random(in: 0...100)
        var students: [Student] = []
        
        for _ in 0...studentsCount {
            fetchStudent { result in
                switch result {
                case .success(let student):
                    students.append(student)
                case .failure(let error):
                    error.localizedDescription
                }
            }
        }
        
        DispatchQueue.main.async {
            completion(.success(students))
        }
        
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
