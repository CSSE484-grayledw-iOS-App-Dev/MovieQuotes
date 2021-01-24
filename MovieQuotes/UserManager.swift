//
//  UserManager.swift
//  MovieQuotes
//
//  Created by Derek Grayless on 1/24/21.
//

import Foundation
import Firebase

class UserManager {
    
    var _collectionRef: CollectionReference
    var _document: DocumentSnapshot?
    var _userListener: ListenerRegistration?
    
    let kCollectionUsers = "Users"
    let kKeyName = "name"
    let kKeyPhotoURL = "photoURL"
    
    static let shared = UserManager()
    
    init() {
        _collectionRef = Firestore.firestore().collection(kCollectionUsers)
    }
    
    // CRUD
    func addUser(uid: String, name: String?, photoUrl: String?) {
        // Get the user to see if they exist
        // Add user ONLY if they don't exist
        let userRef = _collectionRef.document(uid)
        userRef.getDocument { (documentSnapshot, error) in
            if let error = error {
                print("Error getting user: \(error)")
                return
            }
            
            if let documentSnapshot = documentSnapshot {
                if documentSnapshot.exists {
                    print("There is already a user object for this user. Do nothing.")
                    return
                } else {
                    print("Creating a User with document id \(uid)")
                    userRef.setData([
                        self.kKeyName: name ?? "",
                        self.kKeyPhotoURL: photoUrl ?? ""
                    ])
                }
            }
        }
    }
    
    // READ
    func beginListening(uid: String, changeListener: () -> Void) {
        
    }
    
    func stopListening() {
        _userListener?.remove()
    }
    
    // UPDATE
    func updateName(name: String) {
        
    }
    
    func updatePhotoUrl(photoUrl: String) {
        
    }
    
    // DELETE - Can't delete users - No implementation

    // GETTERS
    var name: String {
        if let value = _document?.get(kKeyName) {
            return value as! String
        }
        return ""
    }
    
    var photoUrl: String {
        if let value = _document?.get(kKeyPhotoURL) {
            return value as! String
        }
        return ""
    }
}
