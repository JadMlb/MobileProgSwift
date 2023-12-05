//
//  ViewController.swift
//  todo
//
//  Created by Jad on 27/11/2023.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource
{
    @IBOutlet weak var allTasks: UITableView!
//    var tasks = [Task]()
    let sections = ["Today", "Tomorrow", "This week", "Later"]
    let tasks = [Task (title: "Today test", desc: "test"), Task (title: "Today test 2", desc: "test 2", dueDate: Date (timeIntervalSinceNow: 100000))]
    
    func tableView (_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return sections.count
    }
    
    func tableView (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell (withIdentifier: "sectionContent", for: indexPath) as! SectionTableViewCell
        cell.toggleView.titleLabel?.text = sections[indexPath.row]
//        let df = DateFormatter()
//        df.dateFormat = "dd"
//        cell.taskList = tasks.filter ({(e : Task) -> Bool in return e.dueDate? ? df.string (from: e.dueDate) == df.string (from: Date()) : true})
        if (sections[indexPath.row] == "Today")
        {
            cell.taskList = tasks
        }
        return cell
    }
    
    override func viewDidLoad ()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        allTasks.dataSource = self
    }
}

