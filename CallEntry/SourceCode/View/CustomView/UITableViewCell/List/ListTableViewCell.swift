//
//  ListTableViewCell.swift
//  CallEntry
//
//  Created by HMSPL on 26/02/19.
//  Copyright © 2019 Gowtham. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureData(title: String) {
        lblTitle.text = "\(title)"
    }
    
}
