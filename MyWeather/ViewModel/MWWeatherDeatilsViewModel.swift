//
//  MWWeatherDeatilsViewModel.swift
//  MyWeather
//
//  Created by Ganesan, Veeramani - Contractor {BIS} on 7/22/18.
//  Copyright © 2018 Ganesan, Veeramani - Contractor {BIS}. All rights reserved.
//

//  This class is the view model for WeatherDeatilsViewController. This provides the presentation logic for WeatherDeatilsViewController and interface to data model and persistent store layer

import UIKit

enum LocationDetailsStatus {
    
    case success
    case failure
}

class MWWeatherDeatilsViewModel {
    
    var weatherDetails: MWBox<MWWeatherDetailsModel> = MWBox(MWWeatherDetailsModel())
    
    //Lazy property to load the next 5 days
    private lazy var next5Days: [String] = {
        
        let weekDays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        
        let calendar = Calendar(identifier: .gregorian)
        var next5Days = [String]()
        
        for dayIndex in 1...5 {
            
            let dayDate = calendar.date(byAdding: .day, value: dayIndex, to: Date())
            let dayUnit = calendar.component(.weekday, from: dayDate!)
            next5Days.append(weekDays[dayUnit - 1])
        }
        
        return next5Days
    }()
    
    //Lazy property to map the weather state abbrevation with appropriate images
    private lazy var weatherStates:[String : UIImage] = {
        
        return ["sn": UIImage(named:"snow"), "sl": UIImage(named:"sleet"), "h": UIImage(named:"hail"), "t": UIImage(named:"thunderstrom"), "hr": UIImage(named:"heavy rain"), "lr": UIImage(named:"light rain"), "s": UIImage(named:"showers"), "hc": UIImage(named:"heavy cloud"), "lc": UIImage(named:"light cloud"), "c": UIImage(named:"clear")]
        }() as! [String : UIImage]
    
    init() {
        
    }
    
    func loadLocationDetails(forLocationId locId: UInt) {
        locationDetails(forLocationId: locId)
    }
    
    func getLocationTitle()->String {
        
        if let title = weatherDetails.value.title {
            return title
        }
        return ""
    }
    
    func getLoctionTimeandZone()->String {
        
        if let localTime = weatherDetails.value.localTime {
            if let timeZone = weatherDetails.value.timezone {
                return localTime + " " + timeZone
            }
        }
        return ""
    }
    
    //This function provides the current temprature in degrees
    func getLocationTemperature()->String {
        
        if let dayWeatherDetails = weatherDetails.value.dayDetails {
            return String(format: "%.0f°", dayWeatherDetails[0].temperature!.rounded())
        }
        return ""
    }
    
    //This function provides the maximum temprature in degrees
    func getLocationMaxTemperature()->String {
        
        if let dayWeatherDetails = weatherDetails.value.dayDetails {
            return String(format: "%.0f°", dayWeatherDetails[0].max!.rounded())
        }
        return ""
    }
    
    //This function provides the minimum temprature in degrees
    func getLocationMinTemperature()->String {
        
        if let dayWeatherDetails = weatherDetails.value.dayDetails {
            return String(format: "%.0f°", dayWeatherDetails[0].min!.rounded())
        }
        return ""
    }
    
    func getLocationHumidity()->String {
        
        if let dayWeatherDetails = weatherDetails.value.dayDetails {
            return String(format: "%d", dayWeatherDetails[0].humidity!)
        }
        return ""
    }
    
    func getWeatherDetailsforDayCount()->Int {
        
        if let dayWeatherDetails = weatherDetails.value.dayDetails {
            return (dayWeatherDetails.count - 1)
        }
        
        return 0
    }
    
    //This function provides the weather details for next five days like max, min temperture, day and weather state image
    func getWeatherDetailsforDayIndex(index: Int)->(day:String, max: String, min: String, wstate: UIImage) {
        
        if let dayWeatherDetails = weatherDetails.value.dayDetails {
            
            let weatherAbbr = dayWeatherDetails[index + 1].weatherAbbr!
            
            return (next5Days[index], String(format: "%.0f°", dayWeatherDetails[index + 1].max!.rounded()), String(format: "%.0f°", dayWeatherDetails[index + 1].min!.rounded()), self.weatherStates[weatherAbbr]!)
        }
        return ("", "", "", UIImage(named: "unavailable")!)
    }
}

extension MWWeatherDeatilsViewModel {
    
    //This function slice the time for date and time string
    private func sliceTimefromDateTime(_ dateTime: String)->String {
        
        let values = dateTime.components(separatedBy: CharacterSet(charactersIn: "T."))
        return values[1]
    }
    
    //This function retrives the temperature details for the given location from meta weather API. This includes current, min and maximum temperature and next five days temperature details
    private func locationDetails(forLocationId locId: UInt) {
      
        let serviceManager = ServiceManager(withAppUrl: ServiceManager.metaWeatherBaseUrl(), httpEndPoint: "/api/location/\(locId)", httpMethod: "GET", domainName: "MyWeather")
        
        serviceManager.sendRequest(withBody: nil, theHeader: nil) { [unowned self](data, error) in
            
            if let errorStatus = error {
                print(errorStatus)
            }
            else {
                let result = self.parseLocationDetails(responseData: data)
                print(result)
            }
        }
    }
    
    //This function parse the response from location meta weather API. Loads the DayWeatherDetailsModel into dayWeatherDetailsModels list
    private func parseLocationDetails(responseData data: Data?)->(LocationDetailsStatus) {
        
        guard let data = data else {return .failure }
        
        guard let jsonObject = try?JSONSerialization.jsonObject(with: data, options: .allowFragments) else { return .failure}
        
        guard let locationDetails = jsonObject as? [String : Any] else { return .failure }
        
        guard let dayWeatherDetails = locationDetails["consolidated_weather"] as? [Any] else { return .failure }
        
        var dayWeatherDetailsModels = [MWDayWeatherDetailsModel]()
        
        for dayWeatherDetail in dayWeatherDetails {
            
            if let deatils = dayWeatherDetail as? [String : Any] {
                
                let dayWeatherDetailesModel = MWDayWeatherDetailsModel(humidity: deatils["humidity"] as? UInt64, max: deatils["max_temp"] as? Double, min: deatils["min_temp"] as? Double, temperature: deatils["the_temp"] as? Double, weatherState: deatils["weather_state_name"] as? String, weatherAbbr: deatils["weather_state_abbr"] as? String)
                
                dayWeatherDetailsModels.append(dayWeatherDetailesModel)
            }
        }
        
        weatherDetails.value = MWWeatherDetailsModel(title: locationDetails["title"] as? String, id: locationDetails["woeid"] as? UInt64, localTime: sliceTimefromDateTime((locationDetails["time"] as? String)!), timezone: locationDetails["timezone_name"] as? String, dayDetails: dayWeatherDetailsModels)
        
        return .success
    }
}
