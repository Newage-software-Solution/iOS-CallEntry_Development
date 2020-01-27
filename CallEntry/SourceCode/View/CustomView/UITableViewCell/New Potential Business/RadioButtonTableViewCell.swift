//
//  RadioButtonTableViewCell.swift
//  CallEntry
//
//  Created by HMSPL on 19/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

protocol RadioButtonDelegate {
    func Radio(sender: AnyObject,isFirstRadioButtonSelected: Bool)
}

class RadioButtonTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lblTitle: UILabel!
    
   
    @IBOutlet weak var btnFirst: UIButton!
    @IBOutlet weak var btnSecond: UIButton!
    
   
    
    @IBOutlet weak var imgFirstRadioBtn: UIImageView!
    
    @IBOutlet weak var imgSecondRadioBtn: UIImageView!
    
    var checkBox: Bool = false
    
    var delegate: RadioButtonDelegate!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func firstButtonAction(_ sender: Any)
    {
        checkBox = true
        imageTransition(sender)
    }
    
    @IBAction func secondButtonAction(_ sender: Any)
    {
        checkBox = false
        imageTransition(sender)
    }
    
    func configureEditData(profile: Profile,index: IndexPath)
    {
        if index.row == 1
        {
            self.setImage(first: "IMPORT", second: "EXPORT", type: profile.type)
        }
        else if index.row == 2
        {
            self.setImage(first: profile.period == "M" ? "M" : "MONTHLY", second: profile.period == "W" ? "W" : "WEEKLY", type: profile.period)
        }
        else
        {
            self.setImage(first: "C", second: "P", type: profile.currentpotential)
        }
    }
    
    func setImage(first: String,second: String,type: String)
    {
        
        switch type.uppercased()
        {
        case first:
            self.imgFirstRadioBtn.image = UIImage(named: "Radio_on")!
             self.imgSecondRadioBtn.image = UIImage(named: "radioBlueUnselect")!
        case second:
            self.imgSecondRadioBtn.image = UIImage(named: "Radio_on")!
             self.imgFirstRadioBtn.image = UIImage(named: "radioBlueUnselect")!
        default:
            self.imgFirstRadioBtn.image = UIImage(named: "radioBlueUnselect")!
            self.imgSecondRadioBtn.image = UIImage(named: "radioBlueUnselect")!
        }
    }
    
    func imageTransition(_ sender: Any)
    {
        if checkBox
        {
            self.imgFirstRadioBtn.image = UIImage(named: "Radio_on")!
             self.imgSecondRadioBtn.image = UIImage(named: "radioBlueUnselect")!
        }
        else
        {
            self.imgSecondRadioBtn.image = UIImage(named: "Radio_on")!
             self.imgFirstRadioBtn.image = UIImage(named: "radioBlueUnselect")!
        }
        self.delegate.Radio(sender: sender as AnyObject, isFirstRadioButtonSelected: self.checkBox)
    }
    

}
