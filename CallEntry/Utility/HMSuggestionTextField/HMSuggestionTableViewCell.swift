//
//  HMSuggestionTableViewCell.swift
//  ComponentsPlayground
//
//  Created by hmspl on 13/05/17.
//  Copyright © 2017 hmspl. All rights reserved.
//

import UIKit

class HMSuggestionTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lblSuggestion: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureDropDownCell(name: String) {
        
        lblSuggestion.text = name
        lblSuggestion.textAlignment = .center
    }
    
    func configureSuggestionCell(name: String) {
        
        containerView.backgroundColor = UIColor.lightText.withAlphaComponent(0.5)//UIColor(red: 239/255.0, green: 239/255.0, blue: 244/255.0, alpha: 1.0)
        lblSuggestion.text = name

    }
    
}
