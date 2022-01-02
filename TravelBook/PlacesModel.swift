//
//  PlacesModel.swift
//  TravelBook
//
//  Created by Mac on 2.01.2022.
//

import Foundation

class PlacesModel{
    var id:UUID
    var title:String
    var subtitle:String
    var latitude:Double
    var longtitude:Double
    
    init(id:UUID,title:String,subtitle:String,latitude:Double,longtitude:Double) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.latitude = latitude
        self.longtitude = longtitude
    }
    
    
    
}
