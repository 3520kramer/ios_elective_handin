//
//  World.swift
//  QuarantineApp
//
//  Created by Oliver Kramer on 23/05/2020.
//  Copyright © 2020 Oliver Kramer. All rights reserved.
//

import Foundation

class World {
    
    var confirmed: Int
    var deaths: Int
    var recovered: Int
    var active: Int
    
    init(confirmed: Int, deaths: Int, recovered: Int) {
        self.confirmed = confirmed
        self.deaths = deaths
        self.recovered = recovered
        self.active = confirmed - deaths - recovered
    }
    
}
