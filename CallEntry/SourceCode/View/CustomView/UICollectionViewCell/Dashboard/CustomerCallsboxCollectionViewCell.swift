//
//  CustomerCallsboxCollectionViewCell.swift
//  CallEntry
//
//  Created by HMSPL on 10/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

protocol CustomerCallsboxCollectionViewCellDelegate
{
    func shipmentHistoryClicked(callList: Calllist)
}

protocol SummaryPageNavigateDelegate
{
    func tickImageClicked(callList: Calllist)
    
}

protocol CallandMailDelegate
{
    func callandMail(calllist: Calllist)
}

class CustomerCallsboxCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblAction: UILabel!

    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblMode: UILabel!
    @IBOutlet weak var viewdot: UIView!
    
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var btnCallAndMail: UIButton!
    
    @IBOutlet weak var lblVisit: UILabel!
    @IBOutlet weak var imageViewCallAndMail: UIImageView!
    
    @IBOutlet weak var imageTick: UIImageView!
    
    @IBOutlet weak var imgPotentialClient: UIImageView!
    @IBOutlet weak var btnCustomerLocation: UIButton!
    
    var callList: Calllist!
    
    var delegate: CustomerCallsboxCollectionViewCellDelegate?
    
    var summarydelegate: SummaryPageNavigateDelegate?
    
    var delegateCall_Mail: CallandMailDelegate?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(action(sender:)))
        imageTick.addGestureRecognizer(gesture)
    }
  
    
    @IBAction func shipmentHistoryButtonAction(_ sender: Any)
    {
        self.delegate?.shipmentHistoryClicked(callList: callList)
    }
    
    @IBAction func callAndMailButtonAction(_ sender: Any)
    {
        self.delegateCall_Mail?.callandMail(calllist: self.callList)
    }
    
    @objc func action(sender: UIGestureRecognizer)
     {
        self.summarydelegate?.tickImageClicked(callList: self.callList)
    }
    
    @IBAction func locationButtonAction(_ sender: UIButton)
    {
       if let customerDetail = DataBaseModel.getCustomerDetailForID(cusId: callList.custid)
       {
        let url = customerDetail.territory == "" ? "http://maps.apple.com/?address=\(customerDetail.city)" : "http://maps.apple.com/?address=\(customerDetail.territory),\(customerDetail.city)"
            UIApplication.shared.openURL(URL(string:url)!)
        }
    }
    
    
    func configureCellContent(callList: Calllist, deviationDays: Int,isUpcomingCalls: Bool = false) {
        self.callList = callList
        
        lblMode.text = callList.followups[0].mode
        lblAction.text = "  \(callList.followups[0].action.capitalized)  "
        lblDescription.text = callList.followups[0].desc
        
        if deviationDays > 0
        {
            lblDate.text = "\(deviationDays) Days Due"
            viewdot.backgroundColor = UIColor(hex: "#f85858")
        }
        else
        {
            lblDate.text = isUpcomingCalls ? callList.followups[0].followupdate : ""
            viewdot.backgroundColor = UIColor.clear
        }
        
        if let customerDetail = DataBaseModel.getCustomerDetailForID(cusId: callList.custid)
        {
            lblCustomerName.text = customerDetail.name.capitalized
            imgPotentialClient.image = callList.ispotentialclient == "Yes" ? UIImage(named: "potentialClient")! : nil
            let followUp = self.getRecentFollowUp(followUps: callList.followups)
            
            switch followUp.mode.uppercased()
            {
            case "VISIT":
               btnCustomerLocation.setTitle(customerDetail.territory == "" ? "\(customerDetail.city) " : "\(customerDetail.territory),\(customerDetail.city)", for: .normal)
                
                btnCallAndMail.isHidden = true
                imageViewCallAndMail.isHidden = true
                
                btnCustomerLocation.isHidden = false
                lblVisit.isHidden = false
            
            case "PHONE":
                btnCallAndMail.isHidden = false
                imageViewCallAndMail.isHidden = false
                
                btnCustomerLocation.isHidden = true
                lblVisit.isHidden = true
                
                btnCallAndMail.setTitle(customerDetail.phoneno, for: .normal)

                imageViewCallAndMail.image = UIImage(named: "callBlue")
                
            case "MAIL":
                btnCallAndMail.isHidden = false
                imageViewCallAndMail.isHidden = false
                
                btnCustomerLocation.isHidden = true
                lblVisit.isHidden = true
                
                btnCallAndMail.setTitle(customerDetail.emailid, for: .normal)
                imageViewCallAndMail.image = UIImage(named: "mailBlue")

            default:
                btnCallAndMail.isHidden = true
                imageViewCallAndMail.isHidden = true
                
                btnCustomerLocation.isHidden = true
                lblVisit.isHidden = true
            }
        }
    }
    
    func getRecentFollowUp(followUps: [Followup]) -> Followup {
        
        let followUp = followUps.reduce(followUps[0], {DateExtension.greaterThan(lhs: DateExtension.dateFromString(dateString: $0.followupdate, dateFormat: DateFormatString.serverFormat.rawValue)!, rhs: DateExtension.dateFromString(dateString: $1.followupdate, dateFormat: DateFormatString.serverFormat.rawValue)!) ? $1 : $0})
        
        return followUp
    }

}
