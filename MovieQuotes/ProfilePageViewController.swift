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
        displayNameTextField.addTarget(self, action: #selector(handleNameEdit), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserManager.shared.beginListening(uid: Auth.auth().currentUser!.uid, changeListener: updateView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserManager.shared.stopListening()
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
        if UserManager.shared.photoUrl.count > 0 {
            ImageUtilities.load(imageView: profilePhotoImageView, from: UserManager.shared.photoUrl)
        }
        
    }
    
}
