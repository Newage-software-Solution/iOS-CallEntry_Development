//
//  RadioButton.swift
//  CallEntry
//
//  Created by Rajesh on 14/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

@IBDesignable
public class ITRadioButton: UIView {

    @IBOutlet weak var btnTitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var radioButton: UIButton!
    
    @IBInspectable public var radioSelectImage:UIImage!
    
    @IBInspectable public var radioUnselectImage:UIImage!
    
    @IBInspectable public var radioButtonTitle: String = ""


    override public func awakeFromNib() {
        super.awakeFromNib()
        self.btnTitle.text = radioButtonTitle
    }

    @IBAction func radioButtonAction(_ sender: UIButton) {
        
        if sender.isSelected
        {
            sender.isSelected = false
            self.imageView.image = radioUnselectImage
        }
        else
        {
            sender.isSelected = true
            self.imageView.image = radioSelectImage
        }
    }
}
