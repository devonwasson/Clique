//
//  GeofenceManager.swift
//  Clique
//
//  Created by Li Li on 4/19/16.
//  Copyright © 2016 BuckMe. All rights reserved.
//

import UIKit
import CoreLocation

class GeofenceManager: NSObject, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    var viewController: UIViewController
    var geotifications: [Geotification]
    
    init?(viewController: UIViewController) {
        self.viewController = viewController
        if !CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion) {
            print("Genfencing not supported on this device")
            return nil
        }
        self.geotifications = [Geotification]()
    }
    
    func start() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        self.geotifications = Geotification.loadAllGeofitications()
    }
    
    
    func regionWithGeotification(geotification: Geotification) -> CLCircularRegion {
        let region = CLCircularRegion(center: geotification.coordinate, radius: geotification.radius, identifier: geotification.id)
        
        region.notifyOnEntry = true
        region.notifyOnExit = true
        return region
    }
    
    func startMonitoringAllGeotifications() {
        for each in self.geotifications {
            startMonitoringGeotification(each)
        }
    }
    
    func startMonitoringGeotification(geotification: Geotification) {
        // 1
        if !CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion) {
            showSimpleAlertWithTitle("Error", message: "Geofencing is not supported on this device!", viewController: self.viewController)
            return
        }
        // 2
        if CLLocationManager.authorizationStatus() != .AuthorizedAlways {
            showSimpleAlertWithTitle("Warning", message: "Your geotification is saved but will only be activated once you grant Geotify permission to access the device location.", viewController: self.viewController)
        }
        // 3
        let region = regionWithGeotification(geotification)
        // 4
        locationManager.startMonitoringForRegion(region)
    }
    
    // don't think this method will ever be needed but put it here just in case
    func stopMonitoringGeotification(geotification: Geotification) {
        for region in locationManager.monitoredRegions {
            if let circularRegion = region as? CLCircularRegion {
                if circularRegion.identifier == geotification.id {
                    locationManager.stopMonitoringForRegion(circularRegion)
                }
            }
        }
    }
    
    func showSimpleAlertWithTitle(title: String!, message: String, viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alert.addAction(action)
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
    
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        print("Monitoring failed for region with identifier: \(region!.identifier)")
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Location Manager failed with the following error: \(error)")
    }
    
    
    
}
