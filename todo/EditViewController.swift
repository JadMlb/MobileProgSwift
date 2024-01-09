//
//  DetailsViewController.swift
//  todo
//
//  Created by Jad on 13/12/2023.
//

import UIKit

class EditViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate
{
    var data : Task?
    @IBOutlet weak var toggleDatePickerSwitch: UISwitch!
    @IBOutlet weak var editDatePicker: UIDatePicker!
    @IBOutlet weak var editTitleField: UITextField!
    @IBOutlet weak var editDescField: UITextView!
    @IBOutlet weak var popupTitle: UILabel!
    
    override func viewDidLoad ()
    {
        super.viewDidLoad()
        
        if (data != nil && data!.dueDate != nil)
        {
            toggleDatePickerSwitch.isOn = true
            editDatePicker.isHidden = false
            editDatePicker.date = data!.dueDate!
        }
        else
        {
            editDatePicker.isHidden = true
        }
        
        // TextView shadow
        editDescField.layer.cornerRadius = 5
        editDescField.layer.borderWidth = 0.25
        editDescField.layer.borderColor = UIColor.lightGray.cgColor

        // Do any additional setup after loading the view.
        editTitleField.delegate = self
        editDescField.delegate = self
        
        if let task = data
        {
            popupTitle.text = "Edit Task"
            editTitleField.text = task.title
            editDescField.text = task.desc
            if (task.dueDate != nil)
            {
                editDatePicker.date = task.dueDate!
            }
        }
        else
        {
            popupTitle.text = "New Task"
        }
    }
    
    func textFieldShouldReturn (_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        
        if (data == nil)
        {
            data = Task (title: "", desc: "")
        }
        data!.title = editTitleField.text!
        return true
    }
    
    func textViewShouldEndEditing (_ textView: UITextView) -> Bool
    {
        textView.resignFirstResponder()
        
        if (data == nil)
        {
            data = Task (title: "", desc: "")
        }
        data!.desc = editDescField.text!
        return true
    }

    @IBAction func toggleDueDate (_ sender: UISwitch)
    {
        if (sender.isOn)
        {
            editDatePicker.isHidden = false
            // set date 5 min from now (give user some time to achieve the task)
            editDatePicker.date = Date (timeIntervalSinceNow: 300)
            if (data == nil)
            {
                data = Task (title: "", desc: "")
            }
            data!.dueDate = editDatePicker.date
        }
        else
        {
            editDatePicker.isHidden = true
            data!.dueDate = nil
        }
    }
    
    @IBAction func dueDateChanged (_ sender: UIDatePicker)
    {
        if (!editDatePicker.isHidden)
        {
            data!.dueDate = sender.date
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
