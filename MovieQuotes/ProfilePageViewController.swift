//
//  ProfilePageViewController.swift
//  MovieQuotes
//
//  Created by Derek Grayless on 1/24/21.
//

import UIKit
import Firebase

class ProfilePageViewController: UIViewController {
    
    @IBOutlet weak var displayNameTextField: UITextField!

    @IBOutlet weak var profilePhotoImageView: UIImageView!
    
    override func viewDidLoad() {
        UserManager.shared.beginListening(uid: Auth.auth().currentUser!.uid, changeListener: updateView)
        displayNameTextField.addTarget(self, action: #selector(handleNameEdit), for: .editingChanged)
    }
    
    @objc func handleNameEdit() {
        if let name = displayNameTextField.text {
            print("Send the name \(name) to the Firestore!")
            UserManager.shared.updateName(name: name)
        }
    }
    
    @IBAction func pressedEditPhoto(_ sender: Any) {
        print("TODO: Upload a photo!")
    }
    
    func updateView() {
        displayNameTextField.text = UserManager.shared.name
        
        // TODO: Figure out how to load the image for the ImageView asyncronously
    }
    
}
