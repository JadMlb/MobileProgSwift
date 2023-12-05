//
//  SectionTableViewCell.swift
//  todo
//
//  Created by Jad on 27/11/2023.
//

import UIKit

class SectionTableViewCell: UITableViewCell, UITableViewDataSource
{
    @IBOutlet weak var toggleView: UIButton!
    @IBOutlet weak var tasks: UITableView!
    var sectionIsOpen = false
    var taskList = [Task]()
    
    @IBAction func onSectionHeaderClick ()
    {
        sectionIsOpen = !sectionIsOpen
        tasks.isHidden = !sectionIsOpen
        // !! Title is being replaced
    }
    
    override func awakeFromNib ()
    {
        super.awakeFromNib()
        // Initialization code

        tasks.dataSource = self
        tasks.isHidden = !sectionIsOpen
    }

    override func setSelected (_ selected: Bool, animated: Bool)
    {
        super.setSelected (selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func tableView (_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        taskList.count
    }
    
    func tableView (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell (withIdentifier: "listItemPair", for: indexPath) as! TaskTableViewCell
        cell.title.text = taskList[indexPath.row].title
        cell.desc.text = taskList[indexPath.row].desc
        cell.isChecked.isOn = taskList[indexPath.row].isDone
        
        return cell
    }
}
