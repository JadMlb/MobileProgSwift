//
//  ViewController.swift
//  todo
//
//  Created by Jad on 27/11/2023.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var allTasks: UITableView!
    let sectionTitles = ["Today", "Tomorrow", "This week", "Later"]
    var sections = [false, false, false, false]
    var tasks = [Task (title: "Today test", desc: "test"), Task (title: "Today test 2", desc: "test 2", dueDate: Date (timeIntervalSinceNow: 100000))]
    var tasksFiltered = [[Task](), [Task](), [Task](), [Task]()]
    
    func numberOfSections (in tableView: UITableView) -> Int
    {
        tasksFiltered.count
    }
    
    func tableView (_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return sections[section] ? tasksFiltered[section].count + 1 : 1
    }
    
    func tableView (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0
        {
            let cell = tableView.dequeueReusableCell (withIdentifier: "section", for: indexPath) as! SectionTableViewCell
            cell.title.text = sectionTitles[indexPath.section]
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell (withIdentifier: "listItem", for: indexPath) as! TaskTableViewCell
            let task = tasksFiltered[indexPath.section][indexPath.row - 1]
            cell.title.text = task.title
            cell.desc.text = task.desc
            cell.isChecked.isOn = task.isDone
            return cell
        }
    }
    
    func tableView (_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if (indexPath.row == 0)
        {
            sections[indexPath.section].toggle()
            tableView.reloadSections (IndexSet (integer: indexPath.section), with: .automatic)
        }
    }
    
    func tableView (_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if (indexPath.row > 0)
        {
            return 85
        }
        return 45
    }
    
    override func prepare (for segue: UIStoryboardSegue, sender: Any?)
    {
        if let vc = segue.destination as? DetailsViewController
        {
            let indexPath = allTasks.indexPathForSelectedRow!
            vc.data = tasksFiltered[indexPath.section][indexPath.row - 1]
        }
    }
    
    override func viewWillAppear (_ animated: Bool)
    {
        super.viewWillAppear (animated)
        allTasks.reloadData()
    }
    
    @IBAction func cancel (_ unwindSegue: UIStoryboardSegue)
    {
        if let vc = unwindSegue.source as? EditViewController
        {
            vc.dismiss (animated: true, completion: nil)
        }
    }
    
    // manage adding new tasks to list
    @IBAction func done (_ unwindSegue: UIStoryboardSegue)
    {
        if let vc = unwindSegue.source as? EditViewController
        {
            if let newTask = vc.data
            {
                addTaskToFiltered (newTask)
                allTasks.reloadData()
            }
        }
    }
    
    func addTaskToFiltered (_ task : Task)
    {
        let date = task.dueDate
        var idx = 0
        
        if (date != nil)
        {
            if (Calendar.current.isDateInToday (date!))
            {
                idx = 1
            }
            else if (Calendar.current.isDateInTomorrow (date!))
            {
                idx = 2
            }
            else
            {
                let nowComps = Calendar.current.dateComponents([.weekOfYear, .year], from: Date.now)
                let taskDateComps = Calendar.current.dateComponents([.weekOfYear, .year], from: date!)
                if (nowComps.year == taskDateComps.year && nowComps.weekOfYear == taskDateComps.weekOfYear)
                {
                    idx = 3
                }
                else if (nowComps.year == taskDateComps.year && nowComps.weekOfYear! < taskDateComps.weekOfYear!)
                {
                    idx = 4
                }
            }
        }
        
        tasksFiltered[idx].append (task)
    }
    
    func filterTasks (_ tasks: [Task])
    {
        for task in tasks
        {
            addTaskToFiltered (task)
        }
    }
    
    override func viewDidLoad ()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        allTasks.dataSource = self
        allTasks.delegate = self
        
        filterTasks (tasks)
    }
}

