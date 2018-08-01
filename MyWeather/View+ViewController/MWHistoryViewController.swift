//
//  MWHistoryViewController.swift
//  MyWeather
//
//  Created by Ganesan, Veeramani - Contractor {BIS} on 7/23/18.
//  Copyright © 2018 Ganesan, Veeramani - Contractor {BIS}. All rights reserved.
//

import UIKit

class MWHistoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let mwHistoryViewModel = MWHistoryViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        mwHistoryViewModel.searchHistory.bind { [weak self] (historyModels) in
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        mwHistoryViewModel.loadHistory()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension MWHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return mwHistoryViewModel.getLocationHistoryCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let historyDetails = mwHistoryViewModel.getLocationHistoryforIndex(index: indexPath.row)
        let historyTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell") as? MWHistoryTableViewCell
        
        historyTableViewCell?.titleLable.text = historyDetails.title
        historyTableViewCell?.idLable.text = historyDetails.id
        historyTableViewCell?.timestampLable.text = historyDetails.timestamp
        historyTableViewCell?.selectionStyle = .none
        
        return historyTableViewCell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
}
