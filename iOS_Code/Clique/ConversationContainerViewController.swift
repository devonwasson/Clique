//
//  ConversationContainerViewController.swift
//  Clique
//
//  Created by Chris Shadek on 4/26/16.
//  Copyright © 2016 BuckMe. All rights reserved.
//

import UIKit

class ConversationContainerViewController: UIViewController {

    @IBOutlet weak var container: UIView!
    
    @IBOutlet weak var bottomView: UIView!
    
    
    var connection : Connection!
    var messageManager = MessageManager()
    var flag = false
    var index = 0

    @IBOutlet weak var inputTextfield: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageManager.connection = self.connection
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ConversationContainerViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ConversationContainerViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        
        let dismissTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: .dismissKeyboard)
        view.addGestureRecognizer(dismissTap)
        
        self.navigationItem.title = self.connection.realUserName
        
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if connection.isAccepted == false{
            let alert = Alert.presentRequestAlert(self)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            let totalSize = keyboardSize.height - (self.tabBarController?.tabBar.frame.size.height)!
            self.view.frame.origin.y -= totalSize
        }
        
        //(self.container as! ConversationTableViewController).tableViewScrollToBottom(true)
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            let totalSize = keyboardSize.height - (self.tabBarController?.tabBar.frame.size.height)!
            self.view.frame.origin.y += totalSize
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
        
        if segue.identifier == "conversationEmbedSegue"{
            let myTableViewController = segue.destinationViewController as! ConversationTableViewController
            myTableViewController.messageManager = self.messageManager
            myTableViewController.connection = self.connection
        }
        
        else if segue.identifier == "toProfileView"{
            let controller = segue.destinationViewController as! OtherProfilesTableViewController
            controller.connection = self.connection
            
        }
            
    }
 

    /* This should dismiss the keyboard
     - Inspired by: http://stackoverflow.com//users//2589276//esq
     */
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func sendButtonPressed(sender: AnyObject) {
        self.messageManager.sendMessage(self.inputTextfield.text!, connection : self.connection)
        self.inputTextfield.text = ""
        dismissKeyboard()
    }

}

private extension Selector{
    
    static let dismissKeyboard =
        #selector(ConversationContainerViewController.dismissKeyboard)
}
