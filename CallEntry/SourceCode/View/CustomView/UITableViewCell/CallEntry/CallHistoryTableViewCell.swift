//
//  CallHistoryTableViewCell.swift
//  CallEntry
//
//  Created by Rajesh on 16/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

class CallHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
   
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblCallMode: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCellContent(callHistory: Callhistory) {
        
        lblDate.text = callHistory.calldate
       // lblName.text = callHistory.salesman
        lblCallMode.text = callHistory.mode
        
    }
    
}
