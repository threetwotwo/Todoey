//
//  ListTableViewController.swift
//  Todoey
//
//  Created by Gary on 8/3/18.
//  Copyright © 2018 Gary. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {

	let itemArray = ["Sleep", "Eat", "Poop"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArray.count
    }

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
		cell.textLabel?.text = itemArray[indexPath.row]
		return cell
	}

	//MARK: - Table view delegate methods
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)

		if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
			 tableView.cellForRow(at: indexPath)?.accessoryType = .none
		} else {
			 tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
		}
	}



}
