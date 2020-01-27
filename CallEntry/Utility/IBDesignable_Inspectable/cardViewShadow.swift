//
//  cardViewShadow.swift
//  CallEntry
//
//  Created by HMSPL on 22/03/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CardView: UIView
{
//    @IBInspectable var cornerradius : CGFloat = 2
//
//
//    @IBInspectable var shadowcolor: UIColor? = UIColor.black
//
//    /// The opacity of the shadow. Defaults to 0. Specifying a value outside the [0,1] range will give undefined results. Animatable.
//    @IBInspectable var shadowopacity: Float = 0.5
//
//    /// The shadow offset. Defaults to (0, -3). Animatable.
//    @IBInspectable var shadowoffset: CGSize = CGSize(width: 0, height: 5)
  
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 2
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize.zero
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 2)
        layer.shadowPath = shadowPath.cgPath
        layer.opacity = 0.5
    }
    
}
