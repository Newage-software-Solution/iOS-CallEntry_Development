//
//  CustomerProfileTableViewCell.swift
//  CallEntry
//
//  Created by Vignesh on 01/07/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

class CustomerProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var btnProfile: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func navigateToProfileScreen(){
        
    }

}
