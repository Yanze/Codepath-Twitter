//
//  ComposeViewController.swift
//  Twitter
//
//  Created by yanze on 4/13/17.
//  Copyright © 2017 yanzeliu. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonPressed))
        navigationItem.leftBarButtonItem = cancel
        navigationController?.navigationBar.barTintColor = .white
    }
    
    func cancelButtonPressed() {
        self.navigationController!.popViewController(animated: true)
    }


    @IBAction func tweetButtonPressed(_ sender: UIButton) {
        // post message
        
    }
    



}
