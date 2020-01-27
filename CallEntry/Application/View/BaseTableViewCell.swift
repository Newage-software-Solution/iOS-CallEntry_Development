//
//  BaseTableViewCell.swift
//  MyCheerTribe
//
//  Created by hmspl on 06/08/17.
//  Copyright © 2017 hmspl. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getViewControllerInstance(storyboardName: String, storyboardId: String) -> AnyObject {
        
        let storyboard  = UIStoryboard(name: storyboardName, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: storyboardId)
        
        return viewController;
    }


}
