//
//  ListTableViewController.swift
//  Todoey
//
//  Created by Gary on 8/3/18.
//  Copyright © 2018 Gary. All rights reserved.
//

import UIKit
import CoreData

class ListTableViewController: UITableViewController {

	//MARK: - IBActions and Outlets

	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		createAlert(title: "Add new item", message: "")
	}

	//MARK: - variables
	var selectedCategory: Category? {
		didSet{
			loadItems()
		}
	}
	var itemArray: [Item] = []
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

	//MARK: - View Controller life cycle

	override func viewDidLoad() {
		super.viewDidLoad()
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
		itemArray[indexPath.row].done = !itemArray[indexPath.row].done
		saveItems()

		tableView.reloadRows(at: [indexPath], with: .automatic)

		tableView.deselectRow(at: indexPath, animated: true)
	}

	func createAlert(title: String, message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default) { (completion) in
			print("Added item")
			let newItem = Item(context: self.context)
			newItem.done = false
			newItem.title = alert.textFields![0].text!
			newItem.parentCategory = self.selectedCategory
			self.itemArray.append(newItem)

			self.tableView.reloadData()
			self.saveItems()
		})
		alert.addTextField { (textField) in
			textField.placeholder = "Enter a to-do"
		}
		present(alert, animated: true)
	}

	func saveItems() {
		do {
			try context.save()
		} catch {
			print(error.localizedDescription)
			}
		}

	func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
		let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
		if let additionalPredicate = predicate {
			request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
		} else {
			request.predicate = categoryPredicate
		}
		do {
			itemArray = try context.fetch(request)
		} catch {
			print("Error fetching data")
		}
	}
}

//MARK: - Search bar methods

extension ListTableViewController: UISearchBarDelegate {

	fileprivate func loadItems(from searchBar: UISearchBar) {
		let request: NSFetchRequest<Item> = Item.fetchRequest()
		let searchPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
		request.predicate = searchPredicate
		request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
		loadItems(with: request, predicate: searchPredicate)
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
