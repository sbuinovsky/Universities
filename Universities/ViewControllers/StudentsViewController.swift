//
//  StudentsViewController.swift
//  Universities
//
//  Created by Станислав Буйновский on 30.11.2021.
//

import UIKit

class StudentsViewController: UITableViewController {

    var university: University!
    private var students: [Student] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = university.name
        
        for _ in 0...5 {
            NetworkManager.share.fetchStudent { [weak self] result in
                switch result {
                case .success(let student):
                    self?.students.append(student)
                    self?.tableView.reloadData()
                case .failure(let error):
                    error.localizedDescription
                }
                
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 1 : students.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        var configuration = cell.defaultContentConfiguration()
        
        switch indexPath.section {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "universitySummaryCell", for: indexPath)
            configuration.text = university.name
            configuration.secondaryText = university.webPages.joined(separator: ", ")
            if let logoImage = ImageManager.shared.fetchLogo(for: university.domains.first) {
                configuration.image = UIImage(data: logoImage)
            } else {
                configuration.image = UIImage(named: "default-university-image")
            }

        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath)
            let student = students[indexPath.row]
            configuration.text = student.name.fullName
            if let photoImage = ImageManager.shared.fetchPhoto(for: student.picture.thumbnail) {
                configuration.image = UIImage(data: photoImage)
            } else {
                configuration.image = UIImage(named: "person.fill")
            }
        }

        configuration.imageProperties.cornerRadius = 10
        cell.contentConfiguration = configuration
        return cell
    }
   
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "Summary" : "Students"
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 100
        default:
            return 60
        }
    }
   
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? StudentDetailedViewController else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        
        destinationVC.student = students[indexPath.row]
    }
}
