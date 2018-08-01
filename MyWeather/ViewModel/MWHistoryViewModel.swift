//
//  MWHistoryViewModel.swift
//  MyWeather
//
//  Created by Ganesan, Veeramani - Contractor {BIS} on 7/23/18.
//  Copyright © 2018 Ganesan, Veeramani - Contractor {BIS}. All rights reserved.
//
//  This class is the view model for HistoryViewController. This provides the presentation logic for HistoryViewController and interface to data model and persistent store layer

import Foundation

class MWHistoryViewModel {
    
    var searchHistory: MWBox<[MWHistoryModel]> = MWBox([])
    
    init() {
        
    }
    
    //This function loads the search history from serialized MWHistoryModel from documents directory using codeble protocol and NSKeyedUnarchiver
    func loadHistory() {
        
        let filePath = MWUtilities.getDocumentsDirectory() + "/LocationSearchHistory"
        
        if let historyModels = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [MWHistoryModel] {
            searchHistory.value = historyModels
        }
    }
    
    func getLocationHistoryCount()->Int {
        
        return searchHistory.value.count
    }
    
    func getLocationHistoryforIndex(index: Int)->(title: String, id: String, timestamp: String) {
        
        if index < searchHistory.value.count  {
            
            return (searchHistory.value[index].title, searchHistory.value[index].id, searchHistory.value[index].timestamp)
        }
        
        return ("", "", "")
    }
}
