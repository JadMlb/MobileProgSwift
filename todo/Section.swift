//
//  Section.swift
//  todo
//
//  Created by Jad on 27/11/2023.
//

import Foundation

class Section
{
    var name : String
    var tasks : [Task]
    
    init (name: String, tasks: [Task])
    {
        self.name = name
        self.tasks = tasks
    }
}
