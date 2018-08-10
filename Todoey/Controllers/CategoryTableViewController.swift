//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Gary on 8/8/18.
//  Copyright © 2018 Gary. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {

	let realm = try! Realm()

	//MARK: - IBActions and Outlets

	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		createAlert(title: "Add category", message: "")
	}

	//MARK: - variables
	var categories: Results<Category>?

	//MARK: - Life cycle

	override func viewDidLoad() {
        super.viewDidLoad()
		print(Realm.Configuration.defaultConfiguration.fileURL!)
		loadCategories()
    }

    // MARK: - Table view data source

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return categories?.count ?? 1
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
		cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
		return cell
	}

	//MARK: - Table view delegate methods

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "goToItems", sender: self)
		tableView.deselectRow(at: indexPath, animated: true)
	}

	//MARK: - Navigation

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let vc = segue.destination as! ListTableViewController
		if let indexPath = tableView.indexPathForSelectedRow {
			vc.selectedCategory = categories?[indexPath.row]
		}
	}

	//MARK: - Data Manipulation methods

	func createAlert(title: String, message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default) { (completion) in
			print("Added item")
			let newCategory = Category()
			newCategory.name = alert.textFields![0].text!

			self.tableView.reloadData()
			self.save(category: newCategory)
		})
		alert.addTextField { (textField) in
			textField.placeholder = "Enter a new category"
		}
		present(alert, animated: true)
	}

	func save(category: Category) {
		do {
			try realm.write {
				realm.add(category)
			}
		} catch {
			print(error.localizedDescription)
		}
		tableView.reloadData()
	}

	func loadCategories() {
		categories = realm.objects(Category.self)
		tableView.reloadData()
	}

}
