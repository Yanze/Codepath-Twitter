//
//  ComposeViewController.swift
//  Twitter
//
//  Created by yanze on 4/13/17.
//  Copyright © 2017 yanzeliu. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {
    

    @IBOutlet weak var userInputTweetTextView: UITextView!
    
    var charCounterLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupUserInputTextView()
 
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCharCounterLabelInNavBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeCharCountLabel()
    }
    
    func setupCharCounterLabelInNavBar() {
        if let navigationBar = self.navigationController?.navigationBar {
            
            charCounterLabel = UILabel(frame: CGRect(x: navigationBar.frame.width-120, y: (navigationBar.frame.height - 20)/2, width: 40, height: 20))
            charCounterLabel.text = "140"
            charCounterLabel.textColor = .gray
            charCounterLabel.font = UIFont(name: charCounterLabel.font.fontName, size: 14)
            navigationBar.addSubview(charCounterLabel)
            
        }
    }
    
    func removeCharCountLabel() {
        charCounterLabel.removeFromSuperview()
    }
    
    func cancelButtonPressed() {
        self.navigationController!.popViewController(animated: true)
    }
    
    func setupNavBar() {
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonPressed))
        navigationItem.leftBarButtonItem = cancel
    }

    func setupUserInputTextView() {
        userInputTweetTextView.delegate = self
        userInputTweetTextView.text = "What's hapenning?"
        userInputTweetTextView.textColor = .lightGray
    }

    @IBAction func tweetButtonPressed(_ sender: UIButton) {
        // post message
        
    }
    
    



}

extension ComposeViewController {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if userInputTweetTextView.textColor == .lightGray {
            userInputTweetTextView.text = ""
            userInputTweetTextView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if userInputTweetTextView.text.isEmpty {
            userInputTweetTextView.text = "What's hapenning?"
            userInputTweetTextView.textColor = .lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let len = userInputTweetTextView.text.characters.count
        charCounterLabel.text = String(format:"%i", (140-len))
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if userInputTweetTextView.text.characters.count == 0 {
            if userInputTweetTextView.text.characters.count != 0 {
                return true
            }
        }
        else if userInputTweetTextView.text.characters.count > 139 {
            return false
        }
        return true
    }
    
}
