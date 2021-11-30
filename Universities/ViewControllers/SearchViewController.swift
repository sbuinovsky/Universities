//
//  ViewController.swift
//  Universities
//
//  Created by Станислав Буйновский on 30.11.2021.
//

import UIKit

class SearchViewController: UIViewController {

    private var country = ""
    
    @IBAction func searchTextChanged(_ sender: UITextField) {
        country = sender.text ?? ""
        country = country.replacingOccurrences(of: " ", with: "+")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? UniversitiesViewController else { return }
        destination.country = country
    }
    
}

