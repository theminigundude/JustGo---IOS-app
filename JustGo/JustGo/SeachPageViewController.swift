//
//  SeachPageViewController.swift
//  JustGo
//
//  Created by Ronan Chang on 2019/5/6.
//  Copyright © 2019 ios.nyu.edu. All rights reserved.
//

import UIKit

class SeachPageViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    var toPass:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 222.0/255.0, green: 160.0/255.0, blue: 65.0/255.0, alpha: 1.0)
    }
    
    //passing data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ListToDetail"{
            let destination = segue.destination as! ItemListScreen
            destination.search_text = searchTextField.text!
            destination.searchController.isActive = true
            destination.searchController.searchBar.text = toPass
            destination.filterContentForSearchText(searchTextField.text!)
            
            
        }
        
    }
    

    @IBAction func search(_ sender: Any) {
        //passing the keyword in textfield to ItemList
        toPass = searchTextField.text!
        print("the text field text is: \(toPass)")
        performSegue(withIdentifier: "SearchToList", sender: self)
        
    }
    
}
