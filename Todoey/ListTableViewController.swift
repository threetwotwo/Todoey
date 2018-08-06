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

	var itemArray: [Item] = []

	override func viewDidLoad() {
		super.viewDidLoad()

		for index in 1...100 {
			itemArray.append(Item(title: "Item \(index)", done: false))
		}
	}


	// MARK: - Table view data source

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		return itemArray.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
		let item = itemArray[indexPath.row]

		cell.textLabel?.text = item.title
		cell.accessoryType = item.done ? .checkmark : .none

		return cell
	}

	//MARK: - Table view delegate methods
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)

		itemArray[indexPath.row].done = !itemArray[indexPath.row].done

		tableView.reloadRows(at: [indexPath], with: .automatic)
	}

	func createAlert(title: String, message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default) { (completion) in
			print("Added item")
			self.itemArray.append(Item(title: alert.textFields![0].text ?? "", done: false))
			self.tableView.reloadData()
		})
		alert.addTextField { (textField) in
			textField.placeholder = "Enter a to-do"
		}
		present(alert, animated: true)
	}


}
