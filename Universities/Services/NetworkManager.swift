//
//  NetworkManager.swift
//  Universities
//
//  Created by Станислав Буйновский on 30.11.2021.
//

import Foundation

fileprivate enum APIPath: String {
    case universities = "http://universities.hipolabs.com/search?country="
    case logo = "https://logo.clearbit.com/"
    case student = "https://randomuser.me/api/"
}

class NetworkManager {
    
    static let share = NetworkManager()
    
    private init() {}
    
//    func fetchHostSummary(for ip: String, completion: @escaping (HostSummaryInfo?) -> Void) {
//
//        let apiPath = "https://api.shodan.io/shodan/host/" + ip + "?key=\(apiKey )"
//
//        guard let url = URL(string: apiPath) else { return }
//
//        URLSession.shared.dataTask(with: url) { data, _, error in
//            guard let data = data else {
//                print(error?.localizedDescription ?? "No error description")
//                return
//            }
//
//            let hostSummaryInfo = self.parseHostSummaryData(withData: data)
//
//            DispatchQueue.main.async {
//                completion(hostSummaryInfo)
//            }
//
//        }.resume()
//    }
//
//    func parseHostSummaryData(withData data: Data) -> HostSummaryInfo? {
//        let decoder = JSONDecoder()
//
//        do {
//            let hostSummaryInfo = try decoder.decode(HostSummaryInfo.self, from: data)
//            return hostSummaryInfo
//        } catch let error {
//            print(error.localizedDescription)
//        }
//        return nil
//    }
}
