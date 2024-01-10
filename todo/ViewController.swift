//
//  ViewController.swift
//  todo
//
//  Created by Jad on 27/11/2023.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIApplicationDelegate, UISearchBarDelegate
{
    @IBOutlet weak var pageTitleLabel: UILabel!
    @IBOutlet weak var allTasks: UITableView!
    var titleLabelText: String = ""
    let sectionTitles = ["Today", "Tomorrow", "This week", "Later"]
    var sections = [false, false, false, false]
    var tasks : [Task] = [] // [Task (title: "Today test", desc: "test"), Task (title: "Today test 2", desc: "test 2", dueDate: Date (timeIntervalSinceNow: 100000))]
    var tasksOrganized = [[Task](), [Task](), [Task](), [Task]()]
    var filteredTasks = [[Task](), [Task](), [Task](), [Task]()]
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    func numberOfSections (in tableView: UITableView) -> Int
    {
        return tasksOrganized.count
    }
    
    func tableView (_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return sections[section] ? filteredTasks[section].count + 1 : 1
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
            let task = filteredTasks[indexPath.section][indexPath.row - 1]
            cell.title.text = task.title
            cell.desc.text = task.desc
            cell.isChecked.isOn = task.isDone
            cell.originalData = task
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
    
    func tableView (_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let configuration = UISwipeActionsConfiguration (actions: [UIContextualAction(style: .destructive, title: "Delete", handler: {(action, view, completionHandler) in
                let row = indexPath.row
                let section = indexPath.section
            self.deleteFromOrganized(task: self.filteredTasks[section][row - 1])
            self.filteredTasks[section].remove (at: row - 1)
            completionHandler (true)
            self.allTasks.reloadData()
        })])
        
        return configuration
    }
    
    func deleteFromOrganized (task: Task)
    {
        for i in 0..<tasksOrganized.count
        {
            for j in 0..<tasksOrganized[i].count
            {
                let t = tasksOrganized[i][j]
                if (t.title == task.title && t.desc == task.desc)
                {
                    tasksOrganized[i].remove (at: j)
                }
            }
        }
    }
    
    override func prepare (for segue: UIStoryboardSegue, sender: Any?)
    {
        if let vc = segue.destination as? DetailsViewController
        {
            let indexPath = allTasks.indexPathForSelectedRow!
            vc.data = tasksOrganized[indexPath.section][indexPath.row - 1]
        }
    }
    
    override func viewWillAppear (_ animated: Bool)
    {
        super.viewWillAppear (animated)
        tasksOrganized = [[Task](), [Task](), [Task](), [Task]()]
        filteredTasks = [[Task](), [Task](), [Task](), [Task]()]
        organizeTasks (tasks)
        filterData (by: "")
        allTasks.reloadData()
        save()
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
                addTaskToOrganized (newTask)
                allTasks.reloadData()
            }
        }
    }
    
    func filterData (by: String)
    {
        for i in 0..<tasksOrganized.count
        {
            for task in tasksOrganized[i]
            {
                if by.isEmpty || task.title.lowercased().contains (by.lowercased())
                {
                    filteredTasks[i].append (task)
                }
            }
        }
    }
    
    func searchBar (_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        // clear tasks
        for i in 0...3
        {
            filteredTasks[i] = [Task]()
        }
        
        filterData (by: searchText)
        
        allTasks.reloadData()
    }
    
    func addTaskToOrganized (_ task : Task, addToAllTasks: Bool = false)
    {
        if (addToAllTasks)
        {
            tasks.append (task)
        }
        
        let date = task.dueDate
        var idx = 0
        
        if (date != nil)
        {
            if (Calendar.current.isDateInToday (date!))
            {
                idx = 0
            }
            else if (Calendar.current.isDateInTomorrow (date!))
            {
                idx = 1
            }
            else
            {
                let nowComps = Calendar.current.dateComponents([.weekOfYear, .year], from: Date.now)
                let taskDateComps = Calendar.current.dateComponents([.weekOfYear, .year], from: date!)
                if (nowComps.year == taskDateComps.year && nowComps.weekOfYear == taskDateComps.weekOfYear)
                {
                    idx = 2
                }
                else if (nowComps.year == taskDateComps.year && nowComps.weekOfYear! < taskDateComps.weekOfYear!)
                {
                    idx = 3
                }
            }
        }
        
        tasksOrganized[idx].append (task)
        
        // save on add
        save()
    }
    
    func save ()
    {
        let encoder = JSONEncoder();
        encoder.dateEncodingStrategy = .secondsSince1970
        if let data = try? encoder.encode (tasks)
        {
            if let path = Bundle.main.url(forResource: "tasks", withExtension: "json")
            {
                try? data.write (to: path)
                print ("im here")
            }
        }
    }
    
    func organizeTasks (_ tasks: [Task])
    {
        for task in tasks
        {
            addTaskToOrganized (task)
        }
    }
    
    override func viewDidLoad ()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        allTasks.dataSource = self
        allTasks.delegate = self
        organizeTasks (tasks)
        pageTitleLabel.text = titleLabelText
    }
}

