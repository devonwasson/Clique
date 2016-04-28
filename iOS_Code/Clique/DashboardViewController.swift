//
//  DashboardViewController.swift
//  Clique
//
//  Created by Kyle Raudensky on 4/4/16.
//  Copyright © 2016 BuckMe. All rights reserved.
//

import UIKit
import Parse

class DashboardViewController: UITableViewController, MessageDelegate {
    @IBOutlet weak var segmentedFilter: UISegmentedControl!
    
    var connections = [Connection]()

    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: .eventListUpdate, name: EventListUpdateNotification, object: nil)
        
        //self.connections = [Connection(), Connection()]
        //Test Parse
        ParseFetcher.getOverlappingUsersWithInformation("vJWd1CVvex", completion:
        {
            (connections: [Connection]) in
//            self.connections = connections
//            print(connections)
            
            self.connections = connections
            print(connections)
            NSNotificationCenter.defaultCenter().postNotificationName("EventListUpdateNotification", object: nil)
        })
        
        ParseFetcher.getUserByID("vJWd1CVvex") {
            (qUser: User?) in
            if qUser != nil {
                var user: User = qUser!
                
            } else {
                print("user is nil")
            }
        }
        
        //parseCom.addNewTimePair("vJWd1CVvex", placeID: "ltmIiKOf2K", startTime: "1461301851337", endTime: "1461301861337")
        
        ParseFetcher.getAndSaveAllGeoFences() {
            (places: [Place]) in
            for place in places {
                print(place.longitude)
            }
        }
        
        ParseFetcher.getOverlappingPlaces("vJWd1CVvex") {
            (placeConnections: [PlaceConnection]) in
            print(placeConnections)
        }
        
        var manager = MessageManager()
        manager.setDelegate(self)
        
        
        
        //set event listener for SegmentedControl
//        segmentedFilter.addTarget(self, action: #selector(DashboardViewController.segmentedFilterValueChanged(_:)), forControlEvents: .TouchUpInside)
//        segmentedFilter.addTarget(self, action: #selector(DashboardViewController.segmentedFilterValueChanged(_:)), forControlEvents: .AllEvents)
        
    }
    
    func receivedNewMessages(messages: [Message]) {
        print("Received messages")
        print(messages)
    }
    
    func segmentedFilterValueChanged(segment: UISegmentedControl) {
        if segment.selectedSegmentIndex == 0 {
            //sort connections by recently seen
            print("HERE")
        }
        else if segment.selectedSegmentIndex == 1 {
            //sort connections by most often seen
        }
        else if segment.selectedSegmentIndex == 2 {
            //change view to list locations
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning complete implementation, return the number of sections

        return 1
    }
    
    /*
     Returns the number of rows in a section in the table view
     */
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows

        return self.connections.count
    }
    
    /**
     Called to reload the tableview's data
     */
    func reloadData(){
        // Call Parse Fetcher Function to get array of Connections
    }
    
    /**
     Called when the event list is updated from the server
     */
    func eventListUpdate(notification:NSNotification){
        self.tableView.reloadData()
    }
    
    
    /*
     Configures each cell of the table
     */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> DashboardTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("dashboardCell", forIndexPath: indexPath) as! DashboardTableViewCell
        
        // Configure the cell...
        
        let cellNum = indexPath.row
        let cellConnection = connections[cellNum]
        cell.connection = cellConnection
        cell.updateCell()
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let nextScene = segue.destinationViewController as! OtherProfilesTableViewController
        
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! DashboardTableViewCell
            nextScene.connection = cell.connection
        }
    }
}


// MARK: - Selector

/*
 Inspired by: https://medium.com/swift-programming/swift-selector-syntax-sugar-81c8a8b10df3#.4wgcad6ur
 */
private extension Selector{
    
    static let eventListUpdate =
        #selector(DashboardViewController.eventListUpdate(_:))
}


// MARK: - Notifications

public let EventListUpdateNotification = "EventListUpdateNotification"

