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

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? StudentsViewController else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        
        destination.university = universities[indexPath.row]
    }

}
