//
//  ViewController.swift
//  todo
//
//  Created by Jad on 27/11/2023.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIApplicationDelegate
{
    @IBOutlet weak var allTasks: UITableView!
    let sectionTitles = ["Today", "Tomorrow", "This week", "Later"]
    var sections = [false, false, false, false]
    var tasks : [Task] = [] // [Task (title: "Today test", desc: "test"), Task (title: "Today test 2", desc: "test 2", dueDate: Date (timeIntervalSinceNow: 100000))]
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
                addTaskToFiltered (newTask)
                allTasks.reloadData()
            }
        }
    }
    
    func addTaskToFiltered (_ task : Task)
    {
        tasks.append (task)
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
        
        tasksFiltered[idx].append (task)
        
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
        
        if let path = Bundle.main.path (forResource: "tasks", ofType: "json")
        {
            if let str = try? String (contentsOfFile: path)
            {
                let rawData = Data (str.utf8)
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                if let jsonData = try? decoder.decode (Tasks.self, from: rawData)
                {
                    let tasks = jsonData.tasks
                    filterTasks (tasks)
                }
                else
                {
                    print ("couldn't understand")
                }
            }
            else
            {
                print ("wrong file contents")
            }
        }
        else
        {
            print ("no such file")
        }
    }
    
    func applicationWillTerminate (_ application: UIApplication)
    {
        print ("terminating")
        let encoder = JSONEncoder();
        encoder.dateEncodingStrategy = .secondsSince1970
        if let data = try? encoder.encode (tasks)
        {
            if let path = Bundle.main.url(forResource: "tasks", withExtension: "json")
            {
                try? data.write (to: path)
            }
        }
    }
}

