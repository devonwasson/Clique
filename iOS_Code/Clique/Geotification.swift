//
//  Geotification.swift
//  Clique
//
//  Created by Li Li on 4/19/16.
//  Copyright © 2016 BuckMe. All rights reserved.
//

import UIKit

class Geotification: NSObject {
    var coordinate: CLLocationCoordinate2D
    var radius: CLLocationDistance
    var id: String
    var note: String
    
    // we can change the contructor to take a JSON object of some sort
    init(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance, id: String, note: String) {
        self.coordinate = coordinate
        self.radius = radius
        self.id = id
        self.note = note
    }
    
    class func loadAllGeofitications() -> [Geotification]{
        let places = Place.getAllPlacesFromCoreData()
        var geotifications = [Geotification]() // clear data first
        for place in places {
            var coordinate = CLLocationCoordinate2D()
            coordinate.latitude = place.latitude
            coordinate.longitude = place.longitude
            let geotification = Geotification(coordinate: coordinate, radius: place.radius, id: place.objectId, note: place.name)
            geotifications += [geotification]
        }
        return geotifications
    }
    
    

}
