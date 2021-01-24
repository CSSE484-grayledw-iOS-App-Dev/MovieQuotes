//
//  MovieQuotesTableViewController.swift
//  MovieQuotes
//
//  Created by Derek Grayless on 1/16/21.
//

import UIKit
import Firebase

class MovieQuotesTableViewController: UITableViewController {
    let movieQuoteCellIdentifier = "MovieQuoteCell"
    let detailSegueIdentifier = "DetailSegue"
    var movieQuotesRef: CollectionReference!
    var movieQuotesListener: ListenerRegistration!
    var isShowingAllQuotes = true
    var authStateListenerHandler: AuthStateDidChangeListenerHandle!
    
    var movieQuotes = [MovieQuote]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(showAddQuoteDialog))
        
//        movieQuotes.append(MovieQuote(quote: "I'll be back", movie: "The Terminator"))
//        movieQuotes.append(MovieQuote(quote: "Yo Adrian!", movie: "Rocky"))
        
        // navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(showMenu))
        
        movieQuotesRef = Firestore.firestore().collection("MovieQuotes")
    }
    
//    @objc func showMenu() {
//        // Add a dialog -> dialogs are all about crud
//
//        let alertController = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
//
//        let submitAction = UIAlertAction(title: "Create Quote", style: .default) { (action) in
//            self.showAddQuoteDialog()
//        }
//
//        let showAction = UIAlertAction(title: self.isShowingAllQuotes ? "Show only my quotes" : "Show all quotes", style: .default) { (action) in
//            // Toggle between the show all vs show mine mode
//            self.isShowingAllQuotes = !self.isShowingAllQuotes
//            // Update the list
//            self.startListening()
//        }
//
//        let signOutAction = UIAlertAction(title: "Sign Out", style: .default) { (action) in
//            do {
//                try Auth.auth().signOut()
//                } catch {
//                    print("Sign out error")
//                }
//
//        }
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        alertController.addAction(cancelAction)
//        alertController.addAction(showAction)
//        alertController.addAction(signOutAction)
//        alertController.addAction(submitAction)
//
//        present(alertController, animated: true, completion: nil)
//    }

    @objc func showAddQuoteDialog() {
        // Add a dialog -> dialogs are all about crud
        
        let alertController = UIAlertController(title: "Create a new movie quote", message: "", preferredStyle: .alert)
        
        // Configure
        alertController.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Quote"
        })
        
        alertController.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Movie"
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let submitAction = UIAlertAction(title: "Create Quote", style: .default) { (action) in
            let quoteTextField = alertController.textFields![0] as UITextField
            let movieTextField = alertController.textFields![1] as UITextField
//            print(quoteTextField.text!)
//            print(movieTextField.text!)
//            let newMovieQuote = MovieQuote(quote: quoteTextField.text!, movie: movieTextField.text!)
//            self.movieQuotes.insert(newMovieQuote, at: 0)
//            self.tableView.reloadData()
            self.movieQuotesRef.addDocument(data: [
                "quote": quoteTextField.text!,
                "movie": movieTextField.text!,
                "created": Timestamp.init(),
                "author": Auth.auth().currentUser!.uid
            ])
        }
        alertController.addAction(submitAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let movieQuote = movieQuotes[indexPath.row]
        return Auth.auth().currentUser!.uid == movieQuote.author
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        print(Auth.auth().currentUser)
//
//        if(Auth.auth().currentUser == nil) {
//            // You are not signed in. So sign in anonymously.
//            print("Signing in")
//            Auth.auth().signInAnonymously { (authResult, error) in
//                if let error = error {
//                    print("Error with anonymous auth: \(error)")
//                    return
//                }
//                print("Success! You signed in. Well done!")
//            }
//        } else {
//            // You are already signed in.
//            print("You are already signed in.")
//        }
        
        authStateListenerHandler = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if(Auth.auth().currentUser == nil) {
                print("There is no user. Go back to the login page")
                self.navigationController?.popViewController(animated: true)
            } else {
                print("You are signed in already! Stay on this page.")
            }
        })
        
        if(Auth.auth().currentUser == nil) {
            print("There is no user. Go back to the login page.")
        } else {
            print("You are already signed in.")
        }
        
        tableView.reloadData()
        startListening()
    }
    
    func startListening() {
        if(movieQuotesListener != nil) {
            movieQuotesListener.remove()
        }
        
        var query = movieQuotesRef.order(by: "created", descending: true).limit(to: 50)
        
        if(!isShowingAllQuotes) {
            query = query.whereField("author", isEqualTo: Auth.auth().currentUser!.uid)
        }
        
        movieQuotesListener = query.addSnapshotListener(includeMetadataChanges: true, listener: { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                self.movieQuotes.removeAll()
                querySnapshot.documents.forEach { (documentSnapshot) in
//                    print(documentSnapshot.documentID)
//                    print(documentSnapshot.data())
                    self.movieQuotes.append(MovieQuote(documentSnapshot: documentSnapshot))
                }
                self.tableView.reloadData()
            } else {
                print("Error getting movie quotes \(error!)")
                return
            }
        })
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        movieQuotesListener.remove()
        Auth.auth().removeStateDidChangeListener(authStateListenerHandler)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieQuotes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: movieQuoteCellIdentifier, for: indexPath)
        
        // Configure the cell
        cell.textLabel?.text = movieQuotes[indexPath.row].quote
        cell.detailTextLabel?.text = movieQuotes[indexPath.row].movie
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            movieQuotes.remove(at: indexPath.row)
//            tableView.reloadData()
            let movieQuoteToDelete = movieQuotes[indexPath.row]
            movieQuotesRef.document(movieQuoteToDelete.id!).delete()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == detailSegueIdentifier {
            if let indexPath = tableView.indexPathForSelectedRow {
//                (segue.destination as! MovieQuoteDetailViewController).movieQuote = movieQuotes[indexPath.row]
                // setting pointer in the cloud to row in our table
                (segue.destination as! MovieQuoteDetailViewController).movieQuoteRef = movieQuotesRef.document(movieQuotes[indexPath.row].id!)
            }
        }
    }
}
