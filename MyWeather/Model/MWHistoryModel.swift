//
//  MWHistoryModel.swift
//  MyWeather
//
//  Created by Ganesan, Veeramani - Contractor {BIS} on 7/23/18.
//  Copyright © 2018 Ganesan, Veeramani - Contractor {BIS}. All rights reserved.
//
//  This class is the model class for search history. This class conforms to codable protocol to support serialization & data persistant via encoding and decoding

import Foundation

class MWHistoryModel:NSObject, NSCoding {
    
    var title       : String
    var id          : String
    var timestamp   : String
    
    init(title: String, id: String, timestamp: String) {
        
        self.title = title
        self.id = id
        self.timestamp = timestamp
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
     
        guard let title = aDecoder.decodeObject(forKey: "title") as? String, let timestamp = aDecoder.decodeObject(forKey: "timestamp") as? String, let id = aDecoder.decodeObject(forKey: "id") as? String else { return nil }
        
        self.init(title: title, id: id, timestamp: timestamp)
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.timestamp, forKey: "timestamp")
    }
}
