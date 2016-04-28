//
//  ConversationViewController.swift
//  Clique
//
//  Created by Kyle Raudensky on 4/25/16.
//  Copyright © 2016 BuckMe. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {

    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textFieldView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ConversationViewController.handleTap(_:)))
        var keyboardHidden: Bool = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ConversationViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleTap(gestureRecognizer: UIGestureRecognizer) {
        
    }
    
    
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            //self.scroller.frame..y -= keyboardSize.height
            self.view.frame.origin.y -= keyboardSize.height
            self.tableView.bounds.insetInPlace(dx: 0, dy: -keyboardSize.height)
            //self.scroller.frame.origin.y -= keyboardSize.height
            
            let insets = UIEdgeInsets(top: keyboardSize.height, left: 0, bottom: 0, right: 0)
            self.tableView.contentInset = insets
            self.tableView.scrollIndicatorInsets = insets
            
            
        }
        
        func keyboardWillHide(notification: NSNotification) {
            
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                self.view.frame.origin.y += keyboardSize.height
                self.tableView.bounds.insetInPlace(dx: 0, dy: keyboardSize.height)
                self.tableView.contentInset = UIEdgeInsetsZero
                self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero
            }
            
        }
        
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
