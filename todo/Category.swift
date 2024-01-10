//
//  Categories.swift
//  todo
//
//  Created by Jad on 10/01/2024.
//

import Foundation

class Categories : Codable
{
    var categories: [Category]
    
    init (categories: [Category])
    {
        self.categories = categories
    }
}

class Category : Codable
{
    var name: String
    var tasks: [Task]
    
    init (name: String, tasks: [Task])
    {
        self.name = name
        self.tasks = tasks
    }
}
