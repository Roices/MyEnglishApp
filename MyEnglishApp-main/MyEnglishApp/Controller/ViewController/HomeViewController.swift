//
//  ViewController.swift
//  ReUsableTableViewCell
//
//  Created by Mac on 05/09/2018.
//  Copyright © 2018 UmairAFzal. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController{
    
    
    @IBOutlet weak var tableView: UITableView!
    var SelectedTopic = ""
    var names = ["TOEIC", "Film-Movie","Enviroment", "Education","Career"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        navigationItem.hidesBackButton = true
       
      
    }
}
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        SelectedTopic = names[indexPath.row]
        let mapView = (self.storyboard?.instantiateViewController(identifier: "WordsViewController"))! as WordsViewController
        mapView.topic = SelectedTopic
        self.navigationController?.pushViewController(mapView, animated: true)
      
       
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SampleTableViewCell.cellForTableView(tableView: tableView)
        cell.setupCell(name: names[indexPath.row])
        return cell
    }
    
 
}

