//
//  MyProfileTableViewCell.swift
//  CallEntry
//
//  Created by HMSPL on 17/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit
import Alamofire
class MyProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var imgProfile: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       imgProfile.layer.cornerRadius = self.imgProfile.frame.size.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureData(url: String) {
        
        self.separatorInset.left = 0
        
        DispatchQueue.main.async
            {
            if url != ""
            {
            guard let url = URL(string: url) else { return }
            guard let data = try? Data(contentsOf: url) else { return }
            self.imgProfile.image = UIImage(data: data)
            }
        }
    }

}
