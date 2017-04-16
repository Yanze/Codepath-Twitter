//
//  EnterReplyMessageViewController.swift
//  Twitter
//
//  Created by yanze on 4/15/17.
//  Copyright © 2017 yanzeliu. All rights reserved.
//

import UIKit
import AFNetworking

class EnterReplyMessageViewController: UIViewController, UITextViewDelegate {

    var tweet: Tweet!
    var charCounterLabel: UILabel!
    
    @IBOutlet weak var userInputTextView: UITextView!
    @IBOutlet weak var replyToLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserInputTextView()
        setupNavBar()
        let imageview = UIImageView(frame: CGRect(x: 0, y: 0, width: 39, height: 39))
        imageview.contentMode = .scaleAspectFit
        imageview.layer.cornerRadius = 3
        imageview.layer.masksToBounds = true
        imageview.setImageWith(User.currentUser!.profileUrl!)
        navigationItem.titleView = imageview
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCharCounterLabelInNavBar()
        if let username = tweet.user?.screenName {
            replyToLabel.text = "@\(username)"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeCharCountLabel()
    }
    
    @IBAction func replyTweetPressend(_ sender: UIButton) {
        if let user = tweet.user?.screenName {
            let message = "@\(user) \(userInputTextView.text!)"
            TwitterClient.sharedInstance?.postTweetMessage(message, in_reply_to_status_id: tweet.id!, completionHandler: { (response) in
                self.navigationController?.popToRootViewController(animated: true)
            })
        }
    }
    
    
    func setupUserInputTextView() {
        userInputTextView.delegate = self
        userInputTextView.text = "Tweet your reply..."
        userInputTextView.font = UIFont(name: (userInputTextView.font?.fontName)!, size: 18)
        userInputTextView.textColor = .lightGray
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
    
    func setupNavBar() {
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonPressed))
        navigationItem.leftBarButtonItem = cancel
    }
    
    func cancelButtonPressed() {
        self.navigationController!.popViewController(animated: true)
    }


}


extension EnterReplyMessageViewController {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if userInputTextView.textColor == .lightGray {
            userInputTextView.text = ""
            userInputTextView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if userInputTextView.text.isEmpty {
            userInputTextView.text = "Tweet your reply..."
            userInputTextView.textColor = .lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let len = userInputTextView.text.characters.count
        charCounterLabel.text = String(format:"%i", (140-len))
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if userInputTextView.text.characters.count == 0 {
            if userInputTextView.text.characters.count != 0 {
                return true
            }
        }
        else if userInputTextView.text.characters.count > 139 {
            return false
        }
        return true
    }
    
}
