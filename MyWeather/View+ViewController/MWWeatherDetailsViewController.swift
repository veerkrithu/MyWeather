//
//  MWWeatherDetailsViewController.swift
//  MyWeather
//
//  Created by Ganesan, Veeramani - Contractor {BIS} on 7/21/18.
//  Copyright © 2018 Ganesan, Veeramani - Contractor {BIS}. All rights reserved.
//

import UIKit

class MWWeatherDetailsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var mainStackView:UIStackView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var selectedLocationId: UInt = 0
    private let mwWeatherDetailsViewModel = MWWeatherDeatilsViewModel()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        mainStackView.isHidden = true
        activityIndicator.startAnimating()
        
        mwWeatherDetailsViewModel.weatherDetails.bind(listener: { [weak self] (weatherDetails) in
            
            DispatchQueue.main.async {
                
                if let detailsCount = self?.mwWeatherDetailsViewModel.getWeatherDetailsforDayCount() {
                
                    if detailsCount > 0 {
                        
                        self?.activityIndicator.stopAnimating()
                        self?.mainStackView.isHidden = false
                        
                        self?.titleLabel.text = self?.mwWeatherDetailsViewModel.getLocationTitle()
                        self?.timeLabel.text = self?.mwWeatherDetailsViewModel.getLoctionTimeandZone()
                        self?.maxLabel.text = self?.mwWeatherDetailsViewModel.getLocationMaxTemperature()
                        self?.minLabel.text = self?.mwWeatherDetailsViewModel.getLocationMinTemperature()
                        self?.humidityLabel.text = self?.mwWeatherDetailsViewModel.getLocationHumidity()
                        self?.temperatureLabel.text = self?.mwWeatherDetailsViewModel.getLocationTemperature()
                        
                        self?.tableView.reloadData()
                    }
                }
            }
        })
        
        mwWeatherDetailsViewModel.loadLocationDetails(forLocationId: selectedLocationId)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension MWWeatherDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return mwWeatherDetailsViewModel.getWeatherDetailsforDayCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dayWeatherTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DayWeatherTableViewCell") as! MWDayWeatherTableViewCell
        
        let dayWeatherDetails = mwWeatherDetailsViewModel.getWeatherDetailsforDayIndex(index: indexPath.row)
        
        dayWeatherTableViewCell.dayLabel.text = dayWeatherDetails.day
        dayWeatherTableViewCell.dayHigh.text = dayWeatherDetails.max
        dayWeatherTableViewCell.dayLow.text = dayWeatherDetails.min
        dayWeatherTableViewCell.dayWeatherImage.image = dayWeatherDetails.wstate
        dayWeatherTableViewCell.selectionStyle = .none
        
        return dayWeatherTableViewCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
}
