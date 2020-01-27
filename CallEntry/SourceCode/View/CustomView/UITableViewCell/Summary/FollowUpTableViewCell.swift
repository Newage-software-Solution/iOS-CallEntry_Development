//
//  FollowUpTableViewCell.swift
//  CallEntry
//
//  Created by HMSPL on 19/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

@objc protocol FollowUpTableViewCellDelegates {
    
    @objc optional func textfieldFollowUpDate(followDate : String)
    @objc optional func callModeType(callMode : String)
    @objc optional func followAction(followAction : String)
}


class FollowUpTableViewCell: UITableViewCell {
   
    var followUp = ["Follow-up","Quotation / Solution","Joint Calls","Need Assessment Call","IT Solution Call","Transition Call"]
    
    @IBOutlet weak var textfieldFollowUpDate: HMCompoField!
    @IBOutlet weak var collection: UICollectionView!
    
    @IBOutlet weak var btnPhone: UIButton!
    
    @IBOutlet weak var btnMail: UIButton!
    
    @IBOutlet weak var btnVisit: UIButton!
    
    
    var selectedItem: Int = -1
    
    let columnNum: CGFloat = 2 //use number of columns instead of a static maximum cell width
    var cellWidth: CGFloat = 0
    
    var followUpDelegate : FollowUpTableViewCellDelegates?
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureDatePicker()
        configureViewData()
        
        collection.register(UINib(nibName: "LabelCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "LabelCell")
        
        if let flowLayout = collection.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10) //could not set in storyboard, don't know why
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let flowLayout = collection.collectionViewLayout as? UICollectionViewFlowLayout {
            let spaceBetweenCells = flowLayout.minimumInteritemSpacing * (columnNum - 1)
            let totalCellAvailableWidth = collection.frame.size.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right - spaceBetweenCells
            cellWidth = floor(totalCellAvailableWidth / columnNum);
        }
    }

    
    func configureDatePicker() {
        
        self.textfieldFollowUpDate.pickerType = .ComboDate
        self.textfieldFollowUpDate.minDate = DateExtension.stringFromDate(date: Date(), dateFormat: "dd-MMM-yyyy")!
        self.textfieldFollowUpDate.dateformat = "dd-MMM-yyyy"
        self.textfieldFollowUpDate.pickerDelegate = self
        self.textfieldFollowUpDate.setDate = String(describing: Date())
        self.textfieldFollowUpDate.loadView()
    }
    
    
    func configureViewData() {
       
        self.btnPhone.addTarget(self, action: #selector(modeButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        self.btnMail.addTarget(self, action: #selector(modeButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        self.btnVisit.addTarget(self, action: #selector(modeButtonAction(sender:)), for: UIControlEvents.touchUpInside)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @objc func modeButtonAction(sender: UIButton) {
        
        for i in 1 ..< 4 {
            
            if sender.tag == i {
                
                viewWithTag(sender.tag)?.borderColor = UIColor(red: 0.80, green: 0.07, blue: 0.21, alpha: 1)
            }
            else {
                
                viewWithTag(i)?.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
            }
        }
        
        self.followUpDelegate?.callModeType?(callMode: sender.tag == 1 ? "PHONE" : sender.tag == 2 ? "MAIL" : "VISIT")
    }
}

extension FollowUpTableViewCell: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        //self.collection.contentInset = UIEdgeInsetsMake(0, 0, 0, 5)
        return followUp.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "followupCell", for: indexPath) as! FollowUpActionCollectionViewCell
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LabelCell", for: indexPath) as! LabelCollectionViewCell
        cell.configureWithIndexPath(indexPath: indexPath, selectedItem: selectedItem, followUp : followUp[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let cell = LabelCollectionViewCell.fromNib() {
            
            let cellMargins = cell.layoutMargins.left + cell.layoutMargins.right
            cell.configureWithIndexPath(indexPath: indexPath, selectedItem: selectedItem, followUp : followUp[indexPath.item])
            cell.label.preferredMaxLayoutWidth = cellWidth - cellMargins
            cell.labelWidthLayoutConstraint.constant = cellWidth - cellMargins //adjust the width to be correct for the number of columns
            return cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
            
        } else  {
            
            return CGSize.zero
        }
        
        //let str = followUp[indexPath.row]
        //return CGSize(width: (str.width(withConstraintedHeight: 33, font: UIFont(name: "Roboto-Regular", size: 14.0)!)) + 24, height: 25)
        
//        if UIScreen.main.bounds.width == 320
//        {
//            return indexPath.item == 0 || indexPath.item == 2 ? CGSize(width: 75, height: 25) : indexPath.item == 4 ? CGSize(width: 100, height: 25) : indexPath.row == 3 ? CGSize(width: 150, height: 25) : indexPath.item == 1 ? CGSize(width: 130, height: 25) : CGSize(width: 115, height: 25)
//        }
//        else
//        {
//        return indexPath.item == 0 || indexPath.item == 2 ? CGSize(width: 75, height: 25) : indexPath.item == 4 ? CGSize(width: 110, height: 25) : indexPath.row == 3 ? CGSize(width: 150, height: 25) : CGSize(width: 120, height: 25)
//    }
    }


//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
//    {
//        return 5
//    }
//
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedItem = indexPath.item
        self.followUpDelegate?.followAction?(followAction: followUp[indexPath.item])
        self.collection.reloadData()
    }
}


extension FollowUpTableViewCell : HMPickerDelegate {
    
    func pickerSelected(index : Int, selectedTag : Int,withData : AnyObject) {
        
        self.followUpDelegate?.textfieldFollowUpDate?(followDate: withData as? String ?? "")
    }
}
