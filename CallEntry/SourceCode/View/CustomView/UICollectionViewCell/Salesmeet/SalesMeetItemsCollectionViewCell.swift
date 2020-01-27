//
//  SalesMeetItemsCollectionViewCell.swift
//  CallEntry
//
//  Created by HMSPL on 26/02/19.
//  Copyright © 2019 Gowtham. All rights reserved.
//

import UIKit

class SalesMeetItemsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgItems: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureData(title: String,name: String) {
        
        lblTitle.text = "\(title)"
        
        if let image = UIImage(named: name) {
            imgItems.image = image
        }
        
    }

}
