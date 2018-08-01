//
//  MWSearchViewController.swift
//  MyWeather
//
//  Created by Ganesan, Veeramani - Contractor {BIS} on 7/19/18.
//  Copyright © 2018 Ganesan, Veeramani - Contractor {BIS}. All rights reserved.
//

import UIKit

class MWSearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private let mwSearchViewModel = MWSearchViewModel()
    
    var selectedLocationIndex: UInt? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        (UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self])).leftViewMode = .never
        (UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self])).textColor = UIColor.white
        (UILabel.appearance(whenContainedInInstancesOf: [UISearchBar.self])).textColor = UIColor.white
        
        searchBar.layer.cornerRadius = 20.0
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        mwSearchViewModel.searchLocation.bind { [weak self] (locationModels) in
            
            DispatchQueue.main.async {
               self?.tableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonTapped(sender: UIButton) {
        
        self.dismiss(animated: true) {
            
        }
    }
    
    func selectedLocation(index: UInt)->MWLocationModel? {
        
        return mwSearchViewModel.selectedLocation(index: index)
    }
}

extension MWSearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       
        mwSearchViewModel.throttleSearch(with: searchText.trimmingCharacters(in: CharacterSet.whitespaces))
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        return true
    }
}

extension MWSearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return mwSearchViewModel.getSearchLocationsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let searchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell") as! MWSearchTableViewCell
        
        let searchLocation = mwSearchViewModel.getSearchLocationsDetailsforIndex(index: indexPath.row)
        searchTableViewCell.titleLable.text = searchLocation
        searchTableViewCell.selectionStyle = .none
       
        return searchTableViewCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedLocationIndex = UInt(indexPath.row)
        self.performSegue(withIdentifier: "unwindToHomeView", sender: self)
    }
}
