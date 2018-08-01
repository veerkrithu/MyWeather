//
//  MWSearchViewModel.swift
//  MyWeather
//
//  Created by Ganesan, Veeramani - Contractor {BIS} on 7/19/18.
//  Copyright © 2018 Ganesan, Veeramani - Contractor {BIS}. All rights reserved.
//


//  This class is the view model for SearchViewController. This provides the presentation logic for SearchViewController and interface to data model and service layer

import Foundation

enum SearchLocationStatus {
    
    case success
    case failure
}

class MWSearchViewModel {
    
    private var dispatchWorkItem:DispatchWorkItem
    private let dispatchQueue:DispatchQueue
    
    var searchLocation: MWBox<[MWLocationModel]> = MWBox([])
    
    init() {
        
        //DispatchWorkItem and DispatchQueue with global and concurrency queue
        dispatchWorkItem = DispatchWorkItem(block: {})
        dispatchQueue = DispatchQueue.global(qos: .background)
    }
    
    func selectedLocation(index: UInt)->MWLocationModel? {
        
        if index <= searchLocation.value.count {
            return searchLocation.value[Int(index)]
        }
        else {
            return nil
        }
    }
    
    //Throttle the search to provide maximum efficency while searching, also to avoid more calls to search web services API. 0.2 seconds of delay added between the search API firing. DispatchWorkItem class is used to manage the search task such as add, cancel etc
    func throttleSearch(with searchText: String) {
    
        dispatchWorkItem.cancel()
        
        dispatchWorkItem = DispatchWorkItem(qos: .background, flags: DispatchWorkItemFlags .barrier) { [unowned self] in
            
            print(searchText)
            self.searchLocation(with: searchText)
            
        }
        
        dispatchQueue.asyncAfter(deadline: .now() + 0.2 , execute: dispatchWorkItem)
    }
    
    func getSearchLocationsCount()->Int {
        
        return searchLocation.value.count
    }
    
    func getSearchLocationsDetailsforIndex(index: Int)->(String) {
        
        if index < searchLocation.value.count  {
            return searchLocation.value[index].title
        }
        
        return ""
    }
}

extension MWSearchViewModel {
    
    //This fucntion queries the meta weather API to get the list of locations that matchs the search string
    private func searchLocation(with searchText: String) {
        
        //If the search string is empty clear the search results list
        if searchText.isEmpty {
            resetLocations()
            return
        }
        
        let serviceManager = ServiceManager(withAppUrl: ServiceManager.metaWeatherBaseUrl(), httpEndPoint: "location/search/?query=\(searchText)", httpMethod: "GET", domainName: "MyWeather")
        
        //Asynchronus call to meta weather search query API
        serviceManager.sendRequest(withBody: nil, theHeader: nil) { [unowned self](data, error) in
            
            if let errorStatus = error {
                print(errorStatus)
            }
            else {
                let result = self.parseSearchLocation(responseData: data)
                print(result)
            }
            
        }
    }
    
    //This fucntion parse the results from meta weather search API. Native JSON serialization used for parsing the response
    private func parseSearchLocation(responseData data: Data?)->(SearchLocationStatus) {
        
        guard let data = data else {return .failure }
        
        guard let jsonObject = try?JSONSerialization.jsonObject(with: data, options: .allowFragments) else { return .failure }
        
        guard let locations = jsonObject as? [Any] else {return .failure }
        
        //Load the parsed locations into locationModels ([MWLocationModel]) list
        loadLocations(locations: locations)
        
        return .success
    }
    
    //This function addes MWLocationModel to locationModels list. MWLocationModel contains title, location_type, woeid
    private func loadLocations(locations: [Any]) {
        
        var locationModels = [MWLocationModel]()
        
        for location in locations {
            
            if let locationDict = location as? [String: Any] {
                
                locationModels.append(MWLocationModel(title: locationDict["title"] as! String, type: locationDict["location_type"] as! String, id: locationDict["woeid"] as! UInt64))
            }
        }
        
        searchLocation.value = locationModels
    }
    
    //This function resets the locationModels list
    private func resetLocations() {
        searchLocation.value.removeAll()
    }
}
