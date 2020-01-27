//
//  SegmentTableViewCell.swift
//  CallEntry
//
//  Created by HMSPL on 19/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

protocol segmentDelegate {
    func segment(segment: String,_ sender: AnyObject)
}

class SegmentTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgAir: UIImageView!
    @IBOutlet weak var imgFCL: UIImageView!
    @IBOutlet weak var imgLCL: UIImageView!
    
    var transition: String = ""
    
    var delegate: segmentDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func airButtonAction(_ sender: Any)
    {
        
        transition = "AIR"
        imageTransition(sender)
    }
    @IBAction func fclButtonAction(_ sender: Any)
    {
        transition = "FCL"
        imageTransition(sender)
    }
    
    @IBAction func lclActionButton(_ sender: Any)
    {
        transition = "LCL"
        imageTransition(sender)
    }
    
    func configureEditData(profile: Profile,index: IndexPath)
    {
        
       self.selectingImage(segment: profile.segment)
    }
    
    func imageTransition(_ sender: Any)
    {
        self.delegate.segment(segment: transition, sender as AnyObject)
        self.selectingImage(segment: self.transition)
    }
    
    func selectingImage(segment: String)
    {
        switch segment.uppercased()
        {
        case "AIR":
            
            self.setImage(imageAir: UIImage(named: "Radio_on")!, imageFCL:  UIImage(named: "radioBlueUnselect")!, imageLCL:  UIImage(named: "radioBlueUnselect")!)
        case "FCL":
            
            self.setImage(imageAir:  UIImage(named: "radioBlueUnselect")!, imageFCL:  UIImage(named: "Radio_on")!, imageLCL:  UIImage(named: "radioBlueUnselect")!)
        case "LCL":
            self.setImage(imageAir: UIImage(named: "radioBlueUnselect")!, imageFCL: UIImage(named: "radioBlueUnselect")!, imageLCL:  UIImage(named: "Radio_on")!)
            
        default:
            self.imgAir.image = UIImage(named: "radioBlueUnselect")!
            self.imgFCL.image = UIImage(named: "radioBlueUnselect")!
            self.imgLCL.image = UIImage(named: "radioBlueUnselect")!
        }
    }
    
    // setting the image
    func setImage(imageAir: UIImage,imageFCL: UIImage,imageLCL: UIImage)
    {
        self.imgAir.image =  imageAir
        self.imgFCL.image = imageFCL
        self.imgLCL.image = imageLCL
    }
    
   
}
