//
//  SideBarTableViewController.swift
//  SideMenu3
//
//  Created by yanze on 4/20/17.
//  Copyright © 2017 yanzeliu. All rights reserved.
//

import UIKit


protocol SideBarTableViewControllerDelegate {
    func sideBarControlDidSelectRow(indexPath: IndexPath)
}



class SideBarTableViewController: UITableViewController {
    
    var delegate: SideBarTableViewControllerDelegate?
    var tableData: Array<String> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
    }


    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableData.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
            let selectedView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: cell!.frame.size.width, height: cell!.frame.size.height))
            selectedView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            
            cell!.selectedBackgroundView = selectedView
        }
        
        cell!.backgroundColor = UIColor.clear
        cell!.textLabel?.textColor = UIColor.white
        cell!.textLabel?.text = tableData[indexPath.row]
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.sideBarControlDidSelectRow(indexPath: indexPath)
    }
    

}
