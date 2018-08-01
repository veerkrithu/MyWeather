//
//  MWHomeViewModel.swift
//  MyWeather
//
//  Created by Ganesan, Veeramani - Contractor {BIS} on 7/20/18.
//  Copyright © 2018 Ganesan, Veeramani - Contractor {BIS}. All rights reserved.
//

//  This class is the view model for HomeViewController. This provides the presentation logic for HomeViewController and interface to data model and persistent store layer

import Foundation
import CoreLocation

class MWHomeViewModel {
    
    var homeLocations: MWBox<[MWLocationModel]> = MWBox([])
    
    init() {
        
    }
    
    func getLocationsCount()->Int {
        
         return homeLocations.value.count
    }
    
    func getLocationDetailsforIndex(index: Int)->(title: String, id: String, type: String) {
        
        if index < homeLocations.value.count  {
            
            return (homeLocations.value[index].title, String(homeLocations.value[index].id), homeLocations.value[index].type)
        }
        
        return ("", "", "")
    }
    
    //This function adds the location model to homeLocations list.
    func addLocation(location: MWLocationModel) {
        
        if let index = homeLocations.value.index(where: {$0.id == location.id}) {
            homeLocations.value.remove(at: index)
            homeLocations.value.insert(location, at: index)
        }
        else {
            homeLocations.value.append(location)
        }
        
        let historyModel = MWHistoryModel(title: location.title, id: String(location.id), timestamp: MWUtilities.getCurrentDateandTime())
        
        addtoHistory(location: historyModel)
    }
    
    //This function persists the search locations by serilaization using codable protocol. Same used for dispalying search history
    func addtoHistory(location: MWHistoryModel) {
        
        let filePath = MWUtilities.getDocumentsDirectory() + "/LocationSearchHistory"
        var historyModels = lastFiftyHistory()
        
        if historyModels == nil {
            historyModels = [MWHistoryModel]()
        }
        
        historyModels?.insert(location, at: 0)
        
        //Last 50 search histories will be retrieved
        if historyModels!.count > 50 {
            historyModels = Array(historyModels![0...49])
        }
        
        //Persist the MWHistoryModel
        NSKeyedArchiver.archiveRootObject(historyModels as Any, toFile: filePath)
    }
    
    //This function retrives the search locations by serilaization using codable protocol. Last 50 search items will be retrieved
    func lastFiftyHistory()->[MWHistoryModel]?
    {
        let filePath = MWUtilities.getDocumentsDirectory() + "/LocationSearchHistory"
        
        guard let historyModels = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [MWHistoryModel] else { return nil }
       
        return historyModels
    }
    
    func currentLocationDetails()->(CLLocationCoordinate2D?) {
        
        let locationManager = CLLocationManager()
        
        locationManager.requestWhenInUseAuthorization()
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways) {
            
            return locationManager.location?.coordinate
        }
        
        return nil
    }
}


extension MWHomeViewModel {
    
    //This function queries the meta weather API to get the list of locations that matchs the search string
    private func searchLocation(withLat lat: String, andLong long: String) {
        
        let serviceManager = ServiceManager(withAppUrl: ServiceManager.metaWeatherBaseUrl(), httpEndPoint: "location/search/?lattlong=\(lat,long)", httpMethod: "GET", domainName: "MyWeather")
        
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

    //This function parse the results from meta weather search API. Native JSON serialization used for parsing the response
    private func parseSearchLocation(responseData data: Data?)->(SearchLocationStatus) {
        
        guard let data = data else {return .failure }
        
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else { return .failure }
        
        guard let locations = jsonObject as? [Any] else { return .failure }
        
        //Load the parsed locations into locationModels ([MWLocationModel]) list
        addLocation(locations: locations)
        
        return .success
    }
    
    private func addLocation(locations: [Any]) {
            
        if let locationDict = locations.first as? [String: Any] {
            
            let locationModel = MWLocationModel(title: locationDict["title"] as! String, type: locationDict["location_type"] as! String, id: locationDict["woeid"] as! UInt64)
            
            addLocation(location: locationModel)
        }
    }
}
