//
//  UniversitiesTableViewController.swift
//  Universities
//
//  Created by Станислав Буйновский on 30.11.2021.
//

import UIKit

class UniversitiesViewController: UITableViewController {

    var country: String!
    private var universities: [University] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = country.replacingOccurrences(of: "+", with: " ")
        
        NetworkManager.share.fetchUniversities(for: country) { [weak self] result in
            switch result {
            case .success(let universities):
                self?.universities = universities
                self?.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        universities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "universityCell", for: indexPath)

        let university = universities[indexPath.row]

        var configuration = cell.defaultContentConfiguration()
        configuration.text = university.name
        configuration.secondaryText = university.webPages.joined(separator: ", ")
        configuration.image = UIImage(systemName: "graduationcap.fill")
        
        cell.contentConfiguration = configuration
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? StudentsViewController else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        
        destinationVC.university = universities[indexPath.row]
    }

}
