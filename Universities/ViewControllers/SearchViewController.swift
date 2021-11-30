//
//  ViewController.swift
//  Universities
//
//  Created by Станислав Буйновский on 30.11.2021.
//

import UIKit

class SearchViewController: UIViewController {

    private var country = ""
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? UniversitiesViewController else { return }
        destinationVC.country = country
    }
    
    @IBAction func searchTextChanged(_ sender: UITextField) {
        country = sender.text ?? ""
        country = country.replacingOccurrences(of: " ", with: "+")
    }
    
}

