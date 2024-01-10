//
//  CategoryTableViewCell.swift
//  todo
//
//  Created by Jad on 09/01/2024.
//

import UIKit

class CategoryTableViewCell: UITableViewCell
{
    @IBOutlet weak var categoryTitle: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
