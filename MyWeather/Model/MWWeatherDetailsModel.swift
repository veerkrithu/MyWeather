//
//  MWWeatherDetailsModel.swift
//  MyWeather
//
//  Created by Ganesan, Veeramani - Contractor {BIS} on 7/22/18.
//  Copyright © 2018 Ganesan, Veeramani - Contractor {BIS}. All rights reserved.
//
//  This class is the model class for Weather Details. This holds the current day weather deatils and next 5 days weather details.

import Foundation

struct MWDayWeatherDetailsModel {
    
    var humidity        : UInt64?
    var max             : Double?
    var min             : Double?
    var temperature     : Double?
    var weatherState    : String?
    var weatherAbbr     : String?
}


struct MWWeatherDetailsModel {
    
    var title           : String?
    var id              : UInt64?
    var localTime       : String?
    var timezone        : String?
    var dayDetails      : [MWDayWeatherDetailsModel]?
    
    init(title: String? = nil, id: UInt64? = nil, localTime: String? = nil, timezone: String? = nil, dayDetails: [MWDayWeatherDetailsModel]? = nil) {
        
        self.title = title
        self.id = id
        self.localTime = localTime
        self.timezone = timezone
        self.dayDetails = dayDetails
    }
}
