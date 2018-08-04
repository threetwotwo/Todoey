//
//  ListTableViewController.swift
//  Todoey
//
//  Created by Gary on 8/3/18.
//  Copyright © 2018 Gary. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {

	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		createAlert(title: "Add new item", message: "")
	}

	var itemArray: [String] = []

	override func viewDidLoad() {
		super.viewDidLoad()

		if let items = UserDefaults.standard.array(forKey: "items") as? [String] {
			itemArray = items
		}
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

	func createAlert(title: String, message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default) { (completion) in
			print("Added item")
			self.itemArray.append(alert.textFields?.first?.text ?? "New Item")
			UserDefaults.standard.set(self.itemArray, forKey: "items")
			self.tableView.reloadData()
		})
		alert.addTextField { (textField) in
			textField.placeholder = "Enter a to-do"
		}
		present(alert, animated: true)
	}


}
