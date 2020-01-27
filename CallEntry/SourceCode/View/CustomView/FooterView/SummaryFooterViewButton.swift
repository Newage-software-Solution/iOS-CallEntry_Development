//
//  SummaryFooterViewButton.swift
//  CallEntry
//
//  Created by HMSPL on 22/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

class SummaryFooterViewButton: UIView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
    }
    
    
    func loadViewFromNib() {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "SummaryFooterViewButton", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        
    }
    
    @IBAction func submitButtonAction(_ sender: Any) {
        
    }
    
    
    
}
