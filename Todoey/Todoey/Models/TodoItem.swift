//
//  TodoItem.swift
//  Todoey
//
//  Created by Martynas Narijauskas on 10/4/19.
//  Copyright © 2019 Martynas Narijauskas. All rights reserved.
//

import Foundation

class TodoItem : Encodable, Decodable {
    
    var itemName = ""
    var done = false
    
}
