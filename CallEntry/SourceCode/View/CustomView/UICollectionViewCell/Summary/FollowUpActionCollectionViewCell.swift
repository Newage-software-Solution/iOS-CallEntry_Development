//
//  FollowUpActionCollectionViewCell.swift
//  CallEntry
//
//  Created by HMSPL on 19/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

class FollowUpActionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblFollowUpAction: UILabel!
    @IBOutlet var labelWidthLayoutConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func configureWithIndexPath(indexPath: IndexPath, selectedItem : Int, followUp : String) {
        
        lblFollowUpAction.layer.borderWidth = 1
        lblFollowUpAction.layer.cornerRadius = 12
        lblFollowUpAction.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6).cgColor
        lblFollowUpAction.text = followUp
        lblFollowUpAction.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        
        if indexPath.item == selectedItem {
            
            lblFollowUpAction.layer.borderColor = UIColor(red: 0.80, green: 0.07, blue: 0.21, alpha: 1).cgColor
            lblFollowUpAction.textColor =  UIColor(red: 0.80, green: 0.07, blue: 0.21, alpha: 1)
        }
        
        lblFollowUpAction.preferredMaxLayoutWidth = 50
    }
}
