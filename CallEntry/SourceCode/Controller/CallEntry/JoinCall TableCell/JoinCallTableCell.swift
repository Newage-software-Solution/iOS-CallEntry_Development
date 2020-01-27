//
//  JoinCallTableCell.swift
//  CallEntry
//
//  Created by Newage Software and Solutions on 24/12/19.
//  Copyright © 2019 Rajesh. All rights reserved.
//

import UIKit

class JoinCallTableCell: UITableViewCell {
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.borderColor = #colorLiteral(red: 0.6196078431, green: 0.6196078431, blue: 0.6196078431, alpha: 1)
        backView.borderWidth = 1.0
        backView.layer.cornerRadius = 10.0
    }

}
