//
//  SideNavViewController.swift
//  MovieQuotes
//
//  Created by Derek Grayless on 1/24/21.
//

import UIKit
import Firebase

class SideNavViewController : UIViewController {
    
    
    @IBAction func pressedGoToProfilePage(_ sender: Any) {
        print("Profile")
    }
    
    
    @IBAction func pressedShowAllQuotes(_ sender: Any) {
//        print("All Quotes")
//        print("Presenting view controller is \(presentingViewController)") --> is the navigationController
        
        tableViewController.isShowingAllQuotes = true
        tableViewController.startListening()
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func pressedShowMyQuotes(_ sender: Any) {
        print("My Quotes")
        tableViewController.isShowingAllQuotes = false
        tableViewController.startListening()
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func pressedDeleteQuotes(_ sender: Any) {
        print("Delete Quotes")
        tableViewController.setEditing(!tableViewController.isEditing, animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func pressedSignOut(_ sender: Any) {
        dismiss(animated: false)
        do{
            try Auth.auth().signOut()
        } catch {
            print("Sign Out")
        }
        
    }
    
    var tableViewController: MovieQuotesTableViewController {
        // don't need to specify get below but I like it there
        get {
            let navController = presentingViewController as! UINavigationController
            return navController.viewControllers.last as! MovieQuotesTableViewController
        }
    }
}
