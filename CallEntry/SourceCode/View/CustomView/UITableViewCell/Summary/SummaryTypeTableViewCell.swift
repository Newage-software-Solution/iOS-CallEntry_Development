//
//  SummaryTypeTableViewCell.swift
//  CallEntry
//
//  Created by HMSPL on 19/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit


class SummaryTypeTableViewCell: UITableViewCell {

   
    @IBOutlet weak var imgCompleted: UIImageView!
    
    @IBOutlet weak var imgFollowUp: UIImageView!
    
    @IBOutlet weak var lblCompleted: UILabel!
    @IBOutlet weak var lblFollowUp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configureCellData(imageCompleted: String,imageFollowUp: String,completedTextColor: UIColor,followUpTextColor: UIColor)
    {
        self.imgCompleted.image = UIImage(named: imageCompleted)!
        self.imgFollowUp.image = UIImage(named: imageFollowUp)!
        self.lblCompleted.textColor = completedTextColor
        self.lblFollowUp.textColor = followUpTextColor
    }
   
    
}
