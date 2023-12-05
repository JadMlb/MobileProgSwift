//
//  TaskTableViewCell.swift
//  todo
//
//  Created by Jad on 27/11/2023.
//

import UIKit

class TaskTableViewCell: UITableViewCell
{
    @IBOutlet weak var isChecked: UISwitch!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    
    override func awakeFromNib ()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected (_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
