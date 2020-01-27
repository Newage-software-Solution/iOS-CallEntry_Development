//
//  OrginAutoListTableViewCell.swift
//  CallEntry
//
//  Created by HMSPL on 24/04/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

class OrginAutoListTableViewCell: UITableViewCell {

    @IBOutlet weak var textFieldCustomer: HMSuggestionTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
