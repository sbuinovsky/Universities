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
        
        
        switch indexPath.section {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "universitySummaryCell", for: indexPath)
            var configuration = cell.defaultContentConfiguration()
            configuration.text = university.name
            configuration.secondaryText = university.webPages.joined(separator: ", ")
            if let logoImage = ImageManager.shared.fetchLogo(for: university.domains.first) {
                configuration.image = UIImage(data: logoImage)
            } else {
                configuration.image = UIImage(named: "default-university-image")
            }
            cell.contentConfiguration = configuration

        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath)
            var configuration = cell.defaultContentConfiguration()
            let student = students[indexPath.row]
            configuration.text = student.name.fullName
            cell.contentConfiguration = configuration
        }

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
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

   
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? StudentDetailedViewController else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        
        destination.student = students[indexPath.row]
    }
    

}
