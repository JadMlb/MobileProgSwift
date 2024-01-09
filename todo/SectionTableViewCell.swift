//
//  SectionTableViewCell.swift
//  todo
//
//  Created by Jad on 27/11/2023.
//

import UIKit

class SectionTableViewCell: UITableViewCell
{
    @IBOutlet weak var title: UILabel!
    var sectionIsOpen = false
    
    override func awakeFromNib ()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected (_ selected: Bool, animated: Bool)
    {
        super.setSelected (selected, animated: animated)

        // Configure the view for the selected state
    }
}
