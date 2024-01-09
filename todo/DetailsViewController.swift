//
//  DetailsViewController.swift
//  todo
//
//  Created by Jad on 08/01/2024.
//

import UIKit

class DetailsViewController: UIViewController
{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var dueDate: UIDatePicker!
    var data: Task?
    
    override func viewDidLoad ()
    {
        super.viewDidLoad()
        
        if let task = data
        {
            titleLabel.text = task.title
            descriptionLabel.text = task.desc
            if let dd = task.dueDate
            {
                dueDate.date = dd
            }
            else
            {
                dueDate.isHidden = true
            }
        }
    }
    
    override func prepare (for segue: UIStoryboardSegue, sender: Any?)
    {
        if let vc = segue.destination as? EditViewController
        {
            vc.data = data
        }
    }
    
    @IBAction func cancel (_ unwindSegue: UIStoryboardSegue)
    {
        if let vc = unwindSegue.source as? EditViewController
        {
            vc.dismiss (animated: true, completion: nil)
        }
    }
    
    @IBAction func done (_ unwindSegue: UIStoryboardSegue)
    {
        if let vc = unwindSegue.source as? EditViewController
        {
            if let updatedTask = vc.data
            {
                titleLabel.text = updatedTask.title
                descriptionLabel.text = updatedTask.desc
                if (updatedTask.dueDate != nil)
                {
                    dueDate.isHidden = false
                    dueDate.date = updatedTask.dueDate!
                }
                
                data?.title = updatedTask.title
                data?.desc = updatedTask.desc
                data?.dueDate = updatedTask.dueDate
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
