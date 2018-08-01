//
//  MWDayWeatherTableViewCell.swift
//  MyWeather
//
//  Created by Ganesan, Veeramani - Contractor {BIS} on 7/21/18.
//  Copyright © 2018 Ganesan, Veeramani - Contractor {BIS}. All rights reserved.
//

import UIKit

class MWDayWeatherTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dayHigh: UILabel!
    @IBOutlet weak var dayLow: UILabel!
    @IBOutlet weak var dayWeatherImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
