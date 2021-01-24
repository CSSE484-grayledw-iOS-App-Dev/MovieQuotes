//
//  MovieQuote.swift
//  MovieQuotes
//
//  Created by Derek Grayless on 1/16/21.
//

import Foundation
import Firebase

class MovieQuote {
    var movie: String
    var quote: String
    var id: String?
    var author: String
    
    init(documentSnapshot: DocumentSnapshot) {
        self.id = documentSnapshot.documentID
        let data = documentSnapshot.data()!
        self.quote = data["quote"] as! String
        self.movie = data["movie"] as! String
        self.author = data["author"] as! String
    }
}
