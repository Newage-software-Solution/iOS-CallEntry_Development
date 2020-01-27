//
//  PreCallPlannerCollectionViewCell.swift
//  CallEntry
//
//  Created by HMSPL on 17/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

class PreCallPlannerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblAction: UILabel!
    @IBOutlet weak var lblMode: UILabel!
    @IBOutlet weak var lblVisitPlace: UILabel!
    @IBOutlet weak var lblFollowUpDate: UILabel!
    
    @IBOutlet weak var imgPotentialClient: UIImageView!
    
    @IBOutlet weak var imgMode: UIImageView!
    @IBOutlet weak var btnMode: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       self.layer.cornerRadius = 8
    }
    
    func configureCellData(preCallPlannerList: Calllist,customerList: Customerlist)
    {
        self.lblFollowUpDate.text = preCallPlannerList.followups.first?.followupdate
        self.lblAction.text = preCallPlannerList.followups.first?.action
        if preCallPlannerList.ispotentialclient.uppercased() == "YES"
        {
        self.imgPotentialClient.image = UIImage(named: "potentialClient")
        }
        self.lblCustomerName.text = customerList.name
        
        switch preCallPlannerList.followups.first?.mode.uppercased()
        {
        case "VISIT"?:
            imageShow(visit: true, other: false)
            self.lblVisitPlace.text =  customerList.territory == "" ? "\(customerList.city) " : "\(customerList.territory),\(customerList.city)"
        case "CALL"?:
           imageShow(visit: false, other: true)
            self.imgMode.image = UIImage(named: "callBlue")
            self.btnMode.setTitle(customerList.mobileno, for: .normal)
            
        case "MAIL"?:
            imageShow(visit: false, other: true)
            self.imgMode.image = UIImage(named: "mailBlue")
             self.btnMode.setTitle(customerList.emailid, for: .normal)
        default:
            imageShow(visit: false, other: false)
            break
        }
    }
    
    func imageShow(visit: Bool,other: Bool)
    {
        self.imgMode.isHidden = !other
        self.btnMode.isHidden = !other
        self.lblMode.isHidden = !visit
        self.lblVisitPlace.isHidden = !visit
    }

}


