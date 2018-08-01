//
//  MWHomeTableViewCell.swift
//  MyWeather
//
//  Created by Ganesan, Veeramani - Contractor {BIS} on 7/20/18.
//  Copyright © 2018 Ganesan, Veeramani - Contractor {BIS}. All rights reserved.
//

import UIKit

class MWHomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var typeLable: UILabel!
    @IBOutlet weak var idLable: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
