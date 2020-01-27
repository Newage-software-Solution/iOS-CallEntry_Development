//
//  NewCustomerEntryTableViewCell.swift
//  CallEntry
//
//  Created by HMSPL on 16/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

class NewCustomerEntryTableViewCell: UITableViewCell
{
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var switchPotential: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
