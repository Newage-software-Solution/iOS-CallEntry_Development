//
//  NewCustomerEntryProfileTableViewCell.swift
//  CallEntry
//
//  Created by HMSPL on 16/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

class NewCustomerEntryProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgArrow: UIImageView!
    @IBOutlet weak var viewSeperator: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureData() {
        
        separatorInset.left = 0
        lblTitle.textColor = UIColor.black
        lblTitle.text = "Change Password"
        lblTitle.font = UIFont(name: "Roboto-Medium", size: 15.0)
        imgArrow.image = UIImage(named: "nextArrowRed")!
        viewSeperator.isHidden = false
    }
}
