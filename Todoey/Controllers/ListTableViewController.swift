//
//  ListTableViewController.swift
//  Todoey
//
//  Created by Gary on 8/3/18.
//  Copyright © 2018 Gary. All rights reserved.
//

import UIKit
import RealmSwift

class ListTableViewController: UITableViewController {

	//MARK: - IBActions and Outlets

	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		createAlert(title: "Add new item", message: "")
	}

	//MARK: - variables
	let realm = try! Realm()
	var selectedCategory: Category? {
		didSet{
			loadItems()
		}
	}
	var items: Results<Item>?

	//MARK: - View Controller life cycle

	override func viewDidLoad() {
		super.viewDidLoad()
	}


	// MARK: - Table view data source

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		return items?.count ?? 1
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
		if let item = items?[indexPath.row] {
			cell.textLabel?.text = item.title
			cell.accessoryType = item.done ? .checkmark : .none
		} else {
			cell.textLabel?.text = "No items added"
		}
		return cell
	}

	//MARK: - Table view delegate methods
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let item = items?[indexPath.row] {
			do {
				try realm.write {
					item.done = !item.done
				}
			} catch {
				print("error updating item doneness")
			}
		}

		tableView.reloadRows(at: [indexPath], with: .automatic)

		tableView.deselectRow(at: indexPath, animated: true)
	}

	func createAlert(title: String, message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default) { (completion) in
			print("Added item")

			if let category = self.selectedCategory {
				do {
					try self.realm.write {
						let newItem = Item()
						newItem.dateCreated = Date()
						newItem.title = alert.textFields![0].text!
						category.items.append(newItem)
					}
				} catch {
					print(error)
				}
			}
			self.tableView.reloadData()
		})
		alert.addTextField { (textField) in
			textField.placeholder = "Enter a to-do"
		}
		present(alert, animated: true)
	}

	func loadItems() {
		items = selectedCategory?.items.sorted(byKeyPath: "title")
	}
}

//MARK: - Search bar methods

extension ListTableViewController: UISearchBarDelegate {

	fileprivate func loadItems(from searchBar: UISearchBar) {
		items = selectedCategory?.items.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
	}

	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if (searchBar.text! == "") {
			loadItems()
		} else {
			loadItems(from: searchBar)
		}
		tableView.reloadData()
	}

	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		if searchBar.text?.count != 0 {
			loadItems(from: searchBar)
			tableView.reloadData()
		}
		DispatchQueue.main.async {
			searchBar.resignFirstResponder()
		}
	}
}
