//
//  LeftViewCell.swift
//  LGSideMenuControllerDemo
//

import UIKit

class LeftViewCell: UITableViewCell {

    @IBOutlet var lblMenu: UILabel!

    @IBOutlet weak var imageViewMenu: UIImageView!
    
    @IBOutlet weak var imageViewNextArrow: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool){
        lblMenu.alpha = highlighted ? 0.5 : 1.0
    }
    
    func configureCellSelection(isSelected : Bool , image : String) {
        
        if isSelected
        {
            lblMenu.textColor = UIColor.init(hex: "#Cb1135")
            imageViewNextArrow.image = UIImage(named: "nextArrowRed")
        }
        else
        {
            lblMenu.textColor = UIColor.init(hex: "#585858")
            imageViewNextArrow.image = UIImage(named: "nextArrowGrey")
        }
        
        imageViewMenu.image = UIImage(named: image)
    }

}
