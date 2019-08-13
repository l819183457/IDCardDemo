//
//  ViewController.swift
//  OlderFaceTest
//
//  Created by 公平 on 2019/7/23.
//  Copyright © 2019 ppy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
  
    var dataArr = ["Face Detection","IDCard Detection"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView?.addSubview(UIView(frame: .zero))
        
        
        // Do any additional setup after loading the view.
    }

    
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = dataArr[indexPath.row]
        
//        else if indexPath.row == 2 {
//            cell.textLabel?.text = "Image Labelling"
//        } else if indexPath.row == 3 {
//            cell.textLabel?.text = "Text Recognition"
//        } else if indexPath.row == 4 {
//            cell.textLabel?.text = "Landmark Recognition"
//        }
        let footer = UIView(frame: .zero)
        tableView.tableFooterView = footer
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            performSegue(withIdentifier: "faceSegue", sender: self)
        }
        else if indexPath.row == 1 {
            performSegue(withIdentifier: "IDSegue", sender: self)
        }

    }
}
