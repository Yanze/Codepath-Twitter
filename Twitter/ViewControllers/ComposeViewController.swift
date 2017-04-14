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
    @IBOutlet weak var userProfileImgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    
    
    
    var charCounterLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupUserInputTextView()
        setupCurrentUser()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCharCounterLabelInNavBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeCharCountLabel()
    }
    
    func setupCurrentUser() {
        if let name = User.currentUser?.name{
            nameLabel.text = name
        }
        if let screenName = User.currentUser?.screenName {
            screenNameLabel.text = "@\(screenName)"
        }
        
        userProfileImgView.layer.cornerRadius = 4
        userProfileImgView.layer.masksToBounds = true
        if let imgLink = User.currentUser?.profileUrl {
            userProfileImgView.setImageWith(imgLink)
        }
        
    }
    
    func setupCharCounterLabelInNavBar() {
        if let navigationBar = self.navigationController?.navigationBar {
            
            charCounterLabel = UILabel(frame: CGRect(x: navigationBar.frame.width-120, y: (navigationBar.frame.height - 20)/2, width: 40, height: 20))
            charCounterLabel.text = "140"
            charCounterLabel.textColor = UIColor(red: 242/255, green: 239/255, blue: 239/255, alpha: 1)
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
        userInputTweetTextView.text = "What's happening?"
        userInputTweetTextView.font = UIFont(name: (userInputTweetTextView.font?.fontName)!, size: 18)
        userInputTweetTextView.textColor = .lightGray
    }

    @IBAction func tweetButtonPressed(_ sender: UIButton) {
        // post message
        TwitterClient.sharedInstance?.postTweetMessage(userInputTweetTextView.text!, completionHandler: { (response) in
            if (response["isSuccessful"] != nil) {
                self.navigationController?.popViewController(animated: true)
            }
            else{
                self.showAlertBox()
            }
        })
    }
    
    func showAlertBox() {
        let alertVC = UIAlertController(title: "Tweet not sent", message: "Whoops! You already said that.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
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



