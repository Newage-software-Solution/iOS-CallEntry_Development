//
//  IBDesignableExtension.swift
//  BrotherGas
//
//  Created by Susena on 10/08/16.
//  Copyright © 2016 Hakunamatata solution (P) Ltd. All rights reserved.
//

import UIKit

class IBDesignableExtension {

}

//MARK:- Extension UIView
extension UIView {
    
    @IBInspectable var cornerRadius : CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            //layer.masksToBounds = newValue > 0
            clipsToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth : CGFloat {
        
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor : UIColor {
        
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.shadowColor!)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    /// The opacity of the shadow. Defaults to 0. Specifying a value outside the [0,1] range will give undefined results. Animatable.
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            self.layer.shadowOpacity = newValue
            layer.masksToBounds = false
        }
    }
    
    /// The shadow offset. Defaults to (0, -3). Animatable.
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    /// The blur radius used to create the shadow. Defaults to 3. Animatable.
    @IBInspectable var shadowRadius: Double {
        get {
            return Double(layer.shadowRadius)
        }
        set {
            layer.shadowRadius = CGFloat(newValue)
        }
    }
}

