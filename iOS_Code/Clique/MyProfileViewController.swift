//
//  SecondViewController.swift
//  Clique
//
//  Created by Kyle Raudensky on 4/4/16.
//  Copyright © 2016 BuckMe. All rights reserved.
//

import UIKit
import CoreData

class MyProfileViewController: UIViewController {
    

    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileGender: UILabel!
    @IBOutlet weak var profileEmail: UILabel!
    @IBOutlet weak var profileBio: UITextView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = 10
        
    }
    
    ///
    /// Load user data from CoreData upon confirmation that the view will appear
    ///
    override func viewWillAppear(animated: Bool) {
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        
//        let managedContext = appDelegate.managedObjectContext
//        
//        //Testing CoreData - remove later
//        let entity =  NSEntityDescription.entityForName("User", inManagedObjectContext:managedContext)
//        
//        let user = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext) 
//        
//        //3
//        user.setValue("Kyle", forKey: "name")
//        user.setValue("kdraudensky@gmail.com", forKey: "email")
//        user.setValue("Male", forKey: "gender")
//        user.setValue("Hey, I'm Kyle! I like piña coladas and getting caught in the rain!", forKey: "bio")
//        
//        //4
//        do {
//            try managedContext.save()
//        } catch let error as NSError  {
//            print("Could not save \(error), \(error.userInfo)")
//        }
//        //end CoreData test
//        let fetchRequest = NSFetchRequest(entityName: "User")
//        
//        do {
//            let results = try managedContext.executeFetchRequest(fetchRequest)
//            let userData = results as! [NSManagedObject]
//            
//            profileName.text = userData[0].valueForKey("name") as? String
//            profileEmail.text = userData[0].valueForKey("email") as? String
//            profileBio.text = userData[0].valueForKey("bio") as? String
//            profileGender.text = userData[0].valueForKey("gender") as? String
//            
//        } catch let error as NSError {
//            print("Could not fetch \(error), \(error.userInfo)")
//        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

