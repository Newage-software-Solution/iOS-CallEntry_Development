//
//  ProfileTableViewCell.swift
//  CallEntry
//
//  Created by HMSPL on 15/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

protocol EditButtonDelegate {
    func editButtonAction(button: UIButton)
}

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var textFieldEstimatedRevenue: UITextField!
    
    @IBOutlet weak var textFieldClosureDate: UITextField!
    @IBOutlet weak var lblProfileHeader: UILabel!
    @IBOutlet weak var txtfldSegment: UITextField!
    
    @IBOutlet weak var txtfldType: UITextField!
    
    @IBOutlet weak var txtfldPeriod: UITextField!
    
    @IBOutlet weak var txtfldOrigin: UITextField!
    
    @IBOutlet weak var txtfldDestination: UITextField!
    
    @IBOutlet weak var txtfldCurrent: UITextField!
    
    @IBOutlet weak var txtfldNoOfShipment: UITextField!
    
    @IBOutlet weak var txtfldVolume: UITextField!
    
    @IBOutlet weak var txtfldTOS: UITextField!
    
    @IBOutlet weak var txtfldCommodity: UITextField!
    
    @IBOutlet weak var btnEditPotentialBusiness: UIButton!
    
    var delegate: EditButtonDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCellContent(profile: Profile,section: Int) {
        
        lblProfileHeader.text     = "Profile "+String(section)
        txtfldType.text         = profile.type
        txtfldSegment.text      = profile.segment
        txtfldCommodity.text    =  profile.commoditygroup
        txtfldDestination.text  =    profile.destination
        txtfldNoOfShipment.text =   String( profile.noofshipments)
        txtfldOrigin.text     = profile.origin
        txtfldPeriod.text     = profile.period
        txtfldTOS.text      =  profile.tos
        txtfldType.text     =  profile.type
        txtfldVolume.text   =  profile.volume
        textFieldEstimatedRevenue.text = profile.estimatedrevenue
        textFieldClosureDate.text = profile.closuredate
        txtfldCurrent.text = profile.currentpotential
    }
    
    func configureTextFieldEditing(isEdit: Bool)
    {
        lblProfileHeader.isUserInteractionEnabled = isEdit
        txtfldType.isUserInteractionEnabled = isEdit
        txtfldSegment.isUserInteractionEnabled = isEdit
        txtfldCommodity.isUserInteractionEnabled = isEdit
        txtfldDestination.isUserInteractionEnabled = isEdit
        txtfldNoOfShipment.isUserInteractionEnabled = isEdit
        txtfldOrigin.isUserInteractionEnabled = isEdit
        txtfldPeriod.isUserInteractionEnabled = isEdit
        txtfldTOS.isUserInteractionEnabled = isEdit
        txtfldType.isUserInteractionEnabled = isEdit
        txtfldVolume.isUserInteractionEnabled = isEdit
        textFieldEstimatedRevenue.isUserInteractionEnabled = isEdit
        textFieldClosureDate.isUserInteractionEnabled = isEdit
        txtfldCurrent.isUserInteractionEnabled = isEdit
    }
    
    @IBAction func editPotentialBusinessButtonAction(_ sender: UIButton) {
        self.delegate?.editButtonAction(button: sender)
    }
    
    
    
}
