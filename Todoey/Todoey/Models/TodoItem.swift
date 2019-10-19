//
//  TodoItem.swift
//  Todoey
//
//  Created by Martynas Narijauskas on 10/6/19.
//  Copyright © 2019 Martynas Narijauskas. All rights reserved.
//

import Foundation
import RealmSwift

class TodoItem : Object{
    @objc dynamic var itemName : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: CategoryItem.self, property: "items")
}
