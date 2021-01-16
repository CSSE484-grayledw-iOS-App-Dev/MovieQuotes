//
//  MovieQuote.swift
//  MovieQuotes
//
//  Created by Derek Grayless on 1/16/21.
//

import Foundation

class MovieQuote {
    var movie: String
    var quote: String
    
    init(quote: String, movie: String) {
        self.quote = quote
        self.movie = movie
    }
}
