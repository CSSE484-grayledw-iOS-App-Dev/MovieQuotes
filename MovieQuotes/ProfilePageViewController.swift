//
//  ProfilePageViewController.swift
//  MovieQuotes
//
//  Created by Derek Grayless on 1/24/21.
//

import UIKit
import Firebase
import FirebaseStorage

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
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("You must be on a read device!")
            imagePickerController.sourceType = .camera
        } else {
            print("You are probably on the simulator")
            imagePickerController.sourceType = .photoLibrary
        }
        
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func updateView() {
        displayNameTextField.text = UserManager.shared.name
        
        // TODO: Figure out how to load the image for the ImageView asyncronously
        if UserManager.shared.photoUrl.count > 0 {
            ImageUtilities.load(imageView: profilePhotoImageView, from: UserManager.shared.photoUrl)
        }
        
    }
    
    func uploadImage(_ image: UIImage) {
        if let imageData = ImageUtilities.resize(image: image) {
            
            let storageRef = Storage.storage().reference().child("Users").child(Auth.auth().currentUser!.uid)
            
            let uploadTask = storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                if let error = error {
                    print("Error uploading image: \(error)")
                    return
                }
                
                print("Upload complete!")
                
                // You can also access to download URL after upload.
                storageRef.downloadURL { (url, error) in
                    if let error = error {
                        print("Error getting the download url: \(error)")
                        return
                    }
                    
                    if let downloadURL = url {
                        print("Got the download url: \(downloadURL)")
                        UserManager.shared.updatePhotoUrl(photoUrl: downloadURL.absoluteString)
                        return
                    }
                }
            }
        } else {
            print("Error getting image data")
        }
    }
}

extension ProfilePageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage? {
            print("Using the edited image")
            //profilePhotoImageView.image = image
            uploadImage(image)
            // TODO: Upload to Firestore!
            
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage? {
            print("Using the original image")
            //profilePhotoImageView.image = image
            uploadImage(image)
            // TODO: Upload to Firestore!
        }
        
        picker.dismiss(animated: true)
    }
}
