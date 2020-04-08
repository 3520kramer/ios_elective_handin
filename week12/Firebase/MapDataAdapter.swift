//
//  MapDataAdapter.swift
//  Maps
//
//  Created by Oliver Kramer on 31/03/2020.
//  Copyright © 2020 Oliver Kramer. All rights reserved.
//

import Foundation
import MapKit
import FirebaseFirestore

// This class is responsible for converting Firebases GeoPoint to the MapKits point annotations, so we can use it on the map in the View Controller
class MapDataAdapter{
    
    static func getMKAnnotationsFromData(snap:QuerySnapshot) -> [MKPointAnnotation]{
        
        var markers = [MKPointAnnotation]()

        for doc in snap.documents{
            let map = doc.data()
            
            let title = map["title"] as! String
            let subtitle = map["subtitle"] as! String
            let geoPoint = map["coordinates"] as! GeoPoint
            
            let annotation = MKPointAnnotation()
            
            annotation.title = title
            annotation.subtitle = subtitle
            annotation.coordinate = CLLocationCoordinate2D(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
            
            markers.append(annotation)
            }
        
        return markers
    }
}
