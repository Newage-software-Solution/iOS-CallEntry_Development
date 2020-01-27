//
//  TextFieldHMDatePickerTableViewCell.swift
//  CallEntry
//
//  Created by HMSPL on 07/03/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

class TextFieldHMDatePickerTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var textFieldDatePicker: HMCompoField!
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.textFieldDatePicker.pickerType = .ComboDate
        self.textFieldDatePicker.setDate = String(describing: Date())
        self.textFieldDatePicker.minDate = DateExtension.stringFromDate(date: Date(), dateFormat: "MM/dd/yyyy")!
        self.textFieldDatePicker.loadView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureData(profile: Profile)
    {
        self.textFieldDatePicker.text = profile.closuredate
    }
    
}
