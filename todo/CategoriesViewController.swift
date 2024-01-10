//
//  CategoriesViewController.swift
//  todo
//
//  Created by Jad on 10/01/2024.
//

import UIKit

class CategoriesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var categsTableView: UITableView!
    var categories = [Category]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        categsTableView.dataSource = self
        categsTableView.delegate = self
        
        // import all tasks
        if let path = Bundle.main.path (forResource: "tasks", ofType: "json")
        {
            if let str = try? String (contentsOfFile: path)
            {
                let rawData = Data (str.utf8)
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                if let jsonData = try? decoder.decode (Categories.self, from: rawData)
                {
                    let categs = jsonData
                    categories = categs.categories
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
    
    func tableView (_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return categories.count
    }
    
    func tableView (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell (withIdentifier: "category", for: indexPath) as! CategoryTableViewCell
        cell.categoryTitle.text = categories[indexPath.row].name
        return cell
    }
    
    func tableView (_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let configuration = UISwipeActionsConfiguration (actions: [UIContextualAction(style: .destructive, title: "Delete", handler: {(action, view, completionHandler) in
                let row = indexPath.row
            self.categories.remove (at: row)
            completionHandler (true)
            self.categsTableView.reloadData()
        })])
        
        return configuration
    }
    
    override func prepare (for segue: UIStoryboardSegue, sender: Any?)
    {
        if let dest = segue.destination as? ViewController
        {
            let indexPath = categsTableView.indexPathForSelectedRow!
            dest.tasks = categories[indexPath.row].tasks
            dest.titleLabelText = categories[indexPath.row].name
        }
    }

    @IBAction func cancel (_ unwindSegue: UIStoryboardSegue)
    {
        if let vc = unwindSegue.source as? CategoriesEditViewController
        {
            vc.dismiss (animated: true, completion: nil)
        }
    }
    
    @IBAction func done (_ unwindSegue: UIStoryboardSegue)
    {
        if let vc = unwindSegue.source as? CategoriesEditViewController
        {
            if let newCateg = vc.data
            {
                categories.append (newCateg)
                categsTableView.reloadData()
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
