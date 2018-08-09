//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Gary on 8/8/18.
//  Copyright © 2018 Gary. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

	//MARK: - IBActions and Outlets

	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		createAlert(title: "Add category", message: "")
	}

	//MARK: - variables

	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	var categoriesArray: [Category] = []

	//MARK: - Life cycle

	override func viewDidLoad() {
        super.viewDidLoad()
		loadCategories()
    }

    // MARK: - Table view data source

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return categoriesArray.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
		cell.textLabel?.text = categoriesArray[indexPath.row].name
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
			print(indexPath)
			vc.selectedCategory = categoriesArray[indexPath.row]
		}
	}

	//MARK: - Data Manipulation methods

	func createAlert(title: String, message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default) { (completion) in
			print("Added item")
			let newCategory = Category(context: self.context)
			newCategory.name = alert.textFields![0].text!
			self.categoriesArray.append(newCategory)

			self.tableView.reloadData()
			self.saveCategories()
		})
		alert.addTextField { (textField) in
			textField.placeholder = "Enter a new category"
		}
		present(alert, animated: true)
	}

	func saveCategories() {
		do {
			try context.save()
		} catch {
			print(error.localizedDescription)
		}
	}

	func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
		do {
			categoriesArray = try context.fetch(request)
		} catch {
			print("Error fetching data")
		}
	}

}
