//
//  Category.swift
//  Todoey
//
//  Created by Gary on 8/9/18.
//  Copyright © 2018 Gary. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
	@objc dynamic var name = ""
	let items = List<Item>()
}
