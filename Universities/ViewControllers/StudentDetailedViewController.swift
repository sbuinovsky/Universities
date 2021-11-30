//
//  StudentDetailedViewController.swift
//  Universities
//
//  Created by Станислав Буйновский on 30.11.2021.
//

import UIKit

class StudentDetailedViewController: UIViewController {

    @IBOutlet weak var studentPictureImageView: UIImageView!
    @IBOutlet weak var studentDescriptionLabel: UILabel!
    
    var student: Student!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = student.name.fullName
        
        if let photoImage = ImageManager.shared.fetchPhoto(for: student.picture.large) {
            studentPictureImageView.image = UIImage(data: photoImage)
        } else {
            studentPictureImageView.image = UIImage(named: "person.fill")
        }
        studentPictureImageView.layer.cornerRadius = 20
        
        studentDescriptionLabel.text = student.description
       
    }
    

}
