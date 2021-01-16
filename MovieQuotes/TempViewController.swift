//
//  TempViewController.swift
//  MovieQuotes
//
//  Created by Derek Grayless on 1/7/21.
//

import Foundation

import UIKit

class TempViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tempCellIdentifier, for: indexPath)
        // Configure the cell
        cell.textLabel?.text = "This is row \(indexPath.row)"
        return cell
    }
    
    let tempCellIdentifier = "TempCell";
}
