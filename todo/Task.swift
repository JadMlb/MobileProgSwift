//
//  Tasks.swift
//  todo
//
//  Created by Jad on 27/11/2023.
//

import Foundation

class Task
{
    var isDone : Bool = false
    var title : String
    var desc : String
    var dueDate : Date?
    
    init (title: String, desc: String, dueDate: Date)
    {
        self.title = title
        self.desc = desc
        self.dueDate = dueDate
    }
    
    init (title : String, desc : String)
    {
        self.title = title
        self.desc = desc
    }
}
