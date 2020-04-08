//
//  Marker.swift
//  Maps
//
//  Created by Oliver Kramer on 03/04/2020.
//  Copyright © 2020 Oliver Kramer. All rights reserved.
//

import Foundation
import MapKit

class Marker{
    
    let id: String
    var annotation: MKPointAnnotation
    
    init(id: String, annotation: MKPointAnnotation) {
        self.id = id
        self.annotation = annotation
    }
    
    
    
}
