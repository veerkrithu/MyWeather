//
//  MWUtilities.swift
//  MyWeather
//
//  Created by Ganesan, Veeramani - Contractor {BIS} on 7/23/18.
//  Copyright © 2018 Ganesan, Veeramani - Contractor {BIS}. All rights reserved.
//

//  Utilities class for helper functions such as getting documents directory, get date & time in string format etc

import Foundation

class MWUtilities {
    
    class func getDocumentsDirectory()->String {
        
        return (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.path)!
    }
    
    class func getCurrentDateandTime()->String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: Date())
    }
}
