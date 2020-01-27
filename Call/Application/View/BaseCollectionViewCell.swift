//
//  BaseCollectionViewCell.swift
//  MyCheerTribe
//
//  Created by hmspl on 06/08/17.
//  Copyright © 2017 hmspl. All rights reserved.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
    }
}
