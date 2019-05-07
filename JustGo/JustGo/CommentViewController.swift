//
//  CommentViewController.swift
//  JustGo
//
//  Created by Ronan Chang on 2019/5/7.
//  Copyright © 2019 ios.nyu.edu. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    var commentArr = [rating]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }
    
}


extension CommentViewController: UITableViewDataSource, UITableViewDelegate{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return commentArr.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RatingCell", for: indexPath) as! RatingCell
        let rating: rating

        rating = commentArr[indexPath.row]
        
        cell.setItem(rating: rating)
        return cell
    }
}