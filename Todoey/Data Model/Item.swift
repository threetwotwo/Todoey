//
//  Item.swift
//  Todoey
//
//  Created by Gary on 8/9/18.
//  Copyright © 2018 Gary. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
	@objc dynamic var dateCreated: Date?
	@objc dynamic var title = ""
	@objc dynamic var done = false
	var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
