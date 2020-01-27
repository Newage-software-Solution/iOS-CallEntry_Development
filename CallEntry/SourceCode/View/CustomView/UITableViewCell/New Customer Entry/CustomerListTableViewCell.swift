//
//  CustomerListTableViewCell.swift
//  CallEntry
//
//  Created by Rajesh on 17/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

protocol CallDelegate {
    func callButtonAction(_ sender: Any)
}

protocol ProfileButtonDelegate {
    func profileButtonAction(_ sender: Any)
}

protocol CustomerButtonDelegate {
    func customerEditButtonAction(_ sender: Any)
}

class CustomerListTableViewCell: UITableViewCell {

    @IBOutlet weak var btnPhoneNo: UIButton!
    @IBOutlet weak var btnCustomerName: UIButton!
    @IBOutlet weak var lblLocationDetails: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var btnCall: UIButton!
    
    
    
    var callDelegate: CallDelegate!
    
    var ProfileButtonActionDelegate: ProfileButtonDelegate!
    
    var customerEditButtonDelegate: CustomerButtonDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureCellContent(customerList: Customerlist)
    {
        let phoneNo = customerList.phoneno.replacingOccurrences(of: " ", with: "")
        btnPhoneNo.setTitle(phoneNo, for: .normal)
        //btnCustomerName.setTitle(customerList.name, for: .normal)
        lblUserName.text = customerList.name
        lblUserName.sizeToFit()
        lblLocationDetails.text = "\(customerList.city.capitalizingFirstLetter()), \(customerList.country.capitalizingFirstLetter())"
    }
    
    
    @IBAction func CustomerEditButtonAction(_ sender: Any)
    {
        self.customerEditButtonDelegate.customerEditButtonAction(sender)
    }
    
    @IBAction func callButtonAction(_ sender: Any) {
        self.callDelegate.callButtonAction(sender)
    }
    @IBAction func profileButtonAction(_ sender: Any) {
        self.ProfileButtonActionDelegate.profileButtonAction(sender)
    }
    
    @IBAction func phoneNoButtonAction(_ sender: Any) {
        self.callDelegate.callButtonAction(sender)
    }
}




