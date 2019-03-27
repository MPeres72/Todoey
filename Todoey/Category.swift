//
//  Category.swift
//  Todoey
//
//  Created by Marcos Peres on 27.03.19.
//  Copyright © 2019 Marcos Martins. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
