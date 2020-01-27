//
//  FollowUpListTableViewCell.swift
//  CallEntry
//
//  Created by Rajesh on 16/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

class FollowUpListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblWeekDay: UILabel!
    @IBOutlet weak var viewDeviationIndicator: UIView!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var lblSummary: UILabel!
    
    @IBOutlet weak var lblFollowUpAction: UILabel!
    
    @IBOutlet weak var lblCallMode: UILabel!
    
    @IBOutlet weak var lblDayDeviation: UILabel!
    
    @IBOutlet weak var heightConstraintForLblDeviation: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCellContent(followUp: Followup) {
        
        let followUpDate = DateExtension.dateFromString(dateString: followUp.followupdate, dateFormat: DateFormatString.serverFormat.rawValue)
        
        lblWeekDay.text = DateExtension.getWeekDayForDate(date: followUpDate!, dateFormat: DateFormatString.serverFormat.rawValue)
        lblDate.text = followUp.followupdate
        lblSummary.text = followUp.desc
        lblFollowUpAction.text = "  \(followUp.action)  "
        lblCallMode.text = followUp.mode.capitalized

        lblDayDeviation.text = ""
        viewDeviationIndicator.isHidden = true
        heightConstraintForLblDeviation.constant = 0
        
        if followUp.updateddate == ""
        {
            let todayDate = Date().setTime(hour: 0, min: 0, sec: 0)

            if DateExtension.lesserThan(lhs: todayDate!, rhs: followUpDate!)
            {
                let deviation = DateExtension.findDateDifference(lhs: followUpDate!, rhs: todayDate!) ?? 0
                
                heightConstraintForLblDeviation.constant = 16
                lblDayDeviation.text = "\(deviation) Day Deviation"
                viewDeviationIndicator.isHidden = false
            }
            else
            {
                heightConstraintForLblDeviation.constant = 0
                lblDayDeviation.text = ""
                viewDeviationIndicator.isHidden = true
            }
        }
       
    }
    
}
