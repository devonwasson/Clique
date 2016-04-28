//
//  ConversationContainerViewController.swift
//  Clique
//
//  Created by Chris Shadek on 4/26/16.
//  Copyright © 2016 BuckMe. All rights reserved.
//

import UIKit

class ConversationContainerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ConversationContainerViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ConversationContainerViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        
        let dismissTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: .dismissKeyboard)
        view.addGestureRecognizer(dismissTap)

        // Do any additional setup after loading the view.
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
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            let totalSize = keyboardSize.height - (self.tabBarController?.tabBar.frame.size.height)!
            self.view.frame.origin.y += totalSize
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

    /* This should dismiss the keyboard
     - Inspired by: http://stackoverflow.com//users//2589276//esq
     */
    func dismissKeyboard() {
        view.endEditing(true)
    }
    

}

private extension Selector{
    
    static let dismissKeyboard =
        #selector(ConversationContainerViewController.dismissKeyboard)
}
