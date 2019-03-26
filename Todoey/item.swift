//
//  item.swift
//  Todoey
//
//  Created by Marcos Peres on 25.03.19.
//  Copyright © 2019 Marcos Martins. All rights reserved.
//

import Foundation

class Item: Encodable, Decodable {
    
    var title: String = ""
    var done: Bool = false
    
}
