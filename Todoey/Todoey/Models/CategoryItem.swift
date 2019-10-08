//
//  CategoryItem.swift
//  Todoey
//
//  Created by Martynas Narijauskas on 10/6/19.
//  Copyright © 2019 Martynas Narijauskas. All rights reserved.
//

import Foundation
import RealmSwift

class CategoryItem : Object{
    @objc dynamic var title : String = ""
    let items = List<TodoItem>()
}
