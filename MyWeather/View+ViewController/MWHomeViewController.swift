//
//  MWHomeViewController.swift
//  MyWeather
//
//  Created by Ganesan, Veeramani - Contractor {BIS} on 7/19/18.
//  Copyright © 2018 Ganesan, Veeramani - Contractor {BIS}. All rights reserved.
//

import UIKit

class MWHomeViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    private let mwHomeViewModel = MWHomeViewModel()
    private var selectedLocationId: UInt = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor : UIColor(red:0.203, green:0.611, blue:0.988, alpha:1)
        ]
        
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        mwHomeViewModel.homeLocations.bind { [weak self] (locationModels) in
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let weatherDeatilsViewController = segue.destination as? MWWeatherDetailsViewController
        weatherDeatilsViewController?.selectedLocationId = selectedLocationId
    }
 
    @IBAction func unwindToHomeViewController(unwindSegue: UIStoryboardSegue) {
        
        let searchViewContoller = unwindSegue.source as! MWSearchViewController
        
        if let selectedLocation = searchViewContoller.selectedLocation(index: (searchViewContoller.selectedLocationIndex)!) {
            mwHomeViewModel.addLocation(location: selectedLocation)
        }
       
    }

}

extension MWHomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return mwHomeViewModel.getLocationsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let homeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as! MWHomeTableViewCell
        
        let locationDetails = mwHomeViewModel.getLocationDetailsforIndex(index: indexPath.row)
        
        homeTableViewCell.titleLable.text = locationDetails.title
        homeTableViewCell.typeLable.text = locationDetails.type
        homeTableViewCell.idLable.text = locationDetails.id
        homeTableViewCell.selectionStyle = .none
        
        return homeTableViewCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let locationModel = mwHomeViewModel.homeLocations.value[indexPath.row]
        selectedLocationId = UInt(locationModel.id)
        
        self.performSegue(withIdentifier: "weatherDetailViewSegue", sender: self)
    }
}
