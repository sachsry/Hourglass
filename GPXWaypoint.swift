//
//  GPXWaypoint.swift
//  Hourglass
//
//  Created by Ryan Sachs on 4/18/17.
//  Copyright © 2017 Ryan Sachs. All rights reserved.
//

import Foundation
import MapKit

class BarWaypoint: NSObject, MKAnnotation {
    let barName: String
    let barInfo: String
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    
    init(name: String, barInfo: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        self.barName = name
        self.barInfo = barInfo
        self.latitude = latitude
        self.longitude = longitude
        super.init()
    }
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var title: String? { return barName }
    
    var subtitle: String? { return barInfo }
    
    // NOTE Replace code
    var thumbnailURL: URL? {
        return getImageURL()
    }
    
    private func getImageURL() -> URL? {
        return URL(string: "https://mark.trademarkia.com/logo-images/mbk-enterprises/rj-bentleys-filling-station-73361748.jpg")
    }
    // END Replace
}
