//
//  ProfilePageViewController.swift
//  MovieQuotes
//
//  Created by Derek Grayless on 1/24/21.
//

import UIKit

class ProfilePageViewController: UIViewController {
    
    @IBOutlet weak var displayNameTextField: UITextField!

    @IBOutlet weak var profilePhotoImageView: UIImageView!
    
    override func viewDidLoad() {
        displayNameTextField.addTarget(self, action: #selector(handleNameEdit), for: .editingChanged)
    }
    
    @objc func handleNameEdit() {
        if let name = displayNameTextField.text {
            print("Send the name \(name) to the Firestore!")
        }
    }
    
    @IBAction func pressedEditPhoto(_ sender: Any) {
        print("TODO: Upload a photo!")
    }
    
}
