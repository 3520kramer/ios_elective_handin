//
//  CountrySlug.swift
//  QuarantineApp
//
//  Created by Oliver Kramer on 23/05/2020.
//  Copyright © 2020 Oliver Kramer. All rights reserved.
//

import Foundation

class CountrySlug {
    
    var country: String
    var slug: String
    var iso2: String
    
    init(country: String, slug: String, iso2: String) {
        self.country = country
        self.slug = slug
        self.iso2 = iso2
    }
}
