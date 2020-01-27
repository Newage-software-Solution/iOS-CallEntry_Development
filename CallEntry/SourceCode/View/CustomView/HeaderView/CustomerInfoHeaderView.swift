//
//  CustomerInfoHeaderView.swift
//  CallEntry
//
//  Created by Rajesh on 16/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

protocol CustomerInfoHeaderViewDelegate {
    func shipementHistoryClicked()
    func viewProfileClicked()
    func doneActionClicked()
    func callButtonClicked()
    func locationButtonClicked()
}

class CustomerInfoHeaderView: UIView {

    @IBOutlet weak var lblCustomerName: UILabel!
    
    @IBOutlet weak var lblFollowUpAction: UILabel!
    
    @IBOutlet weak var btnPhoneNo: UIButton!
    
    @IBOutlet weak var lblvisit: UILabel!
    
    @IBOutlet weak var btnLocation: UIButton!
    
    @IBOutlet weak var imgForMode: UIImageView!
    
    var delegate: CustomerInfoHeaderViewDelegate?
    
    //MARK:- View life cycle
    
    override init(frame: CGRect) {
        
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        loadViewFromNib()
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        loadViewFromNib()
        
    }
    
    
    override func awakeFromNib() {
        
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.awakeFromNib()
        
    }
    
    func loadViewFromNib() {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CustomerInfoHeaderView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        
    }
    
    
    func configureCellContent(callList: Calllist) {
        
        if let customerDetail = DataBaseModel.getCustomerDetailForID(cusId: callList.custid)
        {
            lblCustomerName.text = customerDetail.name.capitalized
            
            let followUp = self.getRecentFollowUp(followUps: callList.followups)
            lblFollowUpAction.text = "  \(followUp.action)  "
            
            switch callList.followups[0].mode.uppercased()
            {
            case "PHONE":
                self.setVisibleComponents(imgMode: true, isPhone: true, isLocation: false, isVisit: false)
                
                imgForMode.image = UIImage(named: "callBlue")
                btnPhoneNo.setTitle(customerDetail.phoneno, for: .normal)
            case "MAIL":
                self.setVisibleComponents(imgMode: true, isPhone: true, isLocation: false, isVisit: false)
                btnPhoneNo.setTitle(customerDetail.emailid, for: .normal)
                imgForMode.image = UIImage(named: "mailBlue")
            case "VISIT":
                self.setVisibleComponents(imgMode: false, isPhone: false, isLocation: true, isVisit: true)
                btnLocation.setTitle(customerDetail.city, for: .normal)
                
            default:
                self.setVisibleComponents(imgMode: false, isPhone: false, isLocation: false, isVisit: false)
            }
            
        }
    }
    
    func setVisibleComponents(imgMode: Bool,isPhone: Bool,isLocation: Bool,isVisit: Bool)
    {
        imgForMode.isHidden = !imgMode
        btnPhoneNo.isHidden = !isPhone
        btnLocation.isHidden = !isLocation
        lblvisit.isHidden = !isVisit
    }
    
    func getRecentFollowUp(followUps: [Followup]) -> Followup {
        
        let followUp = followUps.reduce(followUps[0], {DateExtension.greaterThan(lhs: DateExtension.dateFromString(dateString: $0.followupdate, dateFormat: DateFormatString.serverFormat.rawValue)!, rhs: DateExtension.dateFromString(dateString: $1.followupdate, dateFormat: DateFormatString.serverFormat.rawValue)!) ? $1 : $0})
        
        return followUp
    }
    
    
    @IBAction func doneButtonAction(_ sender: Any) {
        print("done")
        self.delegate?.doneActionClicked()
    }
    
    @IBAction func profileButtonAction(_ sender: Any) {
        print("profile")
        self.delegate?.viewProfileClicked()
    }
    
    @IBAction func shipmentHistoryButtonAction(_ sender: Any) {
        print("shipment history")
        self.delegate?.shipementHistoryClicked()
    }
    
    @IBAction func callButtonAction(_ sender: Any) {
        print("call")
        self.delegate?.callButtonClicked()
    }
    
    @IBAction func locationButtonAction(_ sender: UIButton)
    {
        self.delegate?.locationButtonClicked()
    }
    

}
