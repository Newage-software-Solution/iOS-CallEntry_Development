//
//  CountryAutoListTableViewCell.swift
//  CallEntry
//
//  Created by HMSPL on 15/06/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

class CountryAutoListTableViewCell: UITableViewCell {

    @IBOutlet weak var textFieldcountryList: HMSuggestionTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
