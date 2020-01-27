//
//  NewCustomerEntryListTableViewCell.swift
//  CallEntry
//
//  Created by HMSPL on 16/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

class NewCustomerEntryListTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTop: UILabel!
    @IBOutlet weak var txtfldBottom: UITextField!
    @IBOutlet weak var textViewinput: UITextView!
    
    @IBOutlet weak var imgArrow: UIImageView!
    @IBOutlet weak var viewSeperator: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureMyProfileData(inputTitle: String) {
        
        lblTop.text = inputTitle
//        txtfldBottom.text = inputText
    }
    
    func configureEditData(customerList: Customerlist,indexpath: IndexPath)
    {
        if indexpath.row == 0
        {
            self.txtfldBottom.text = customerList.name
            self.textViewinput.text = customerList.name
        }
        else if indexpath.row == 1
        {
            self.textViewinput.text = customerList.address
        }
        else if indexpath.row == 2
        {
            self.txtfldBottom.text = customerList.territory
        }
        else if indexpath.row == 3
        {
            self.txtfldBottom.text = customerList.city
        }
        else if indexpath.row == 4
        {
            self.txtfldBottom.text = customerList.country
        }
        else if indexpath.row == 5
        {
            self.txtfldBottom.text = customerList.phoneno
        }
        else if indexpath.row == 6
        {
            self.txtfldBottom.text = customerList.mobileno
        }
        else if indexpath.row == 7
        {
            self.txtfldBottom.text = customerList.emailid
        }
        else {
            self.txtfldBottom.text = customerList.contactperson
        }
    }
    // potential business
    func configurePotentialBusinessData(indexpath: IndexPath,profile: Profile)
    {
        switch indexpath.row
        {
        case 5:
           self.txtfldBottom.text! = profile.tos
        case 6:
          self.txtfldBottom.text! = profile.commoditygroup
        case 7:
          self.txtfldBottom.text! = profile.noofshipments
        case 8:
          self.txtfldBottom.text! = profile.volume
        case 10:
          self.txtfldBottom.text! = profile.estimatedrevenue
        default:
            break
        }
    }
    
}

