//
//  CategoriesEditViewController.swift
//  todo
//
//  Created by Jad on 10/01/2024.
//

import UIKit

class CategoriesEditViewController: UIViewController, UITextFieldDelegate
{
    var data: Category?
    @IBOutlet weak var categTitle: UITextField!
    
    override func viewDidLoad ()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        categTitle.delegate = self
    }
    
    func textFieldShouldReturn (_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        
        data = Category (name: categTitle.text!, tasks: [])
        return true
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
