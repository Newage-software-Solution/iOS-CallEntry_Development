import UIKit

class LabelCollectionViewCell: UICollectionViewCell
{
    @IBOutlet var label: UILabel!
    @IBOutlet var labelWidthLayoutConstraint: NSLayoutConstraint! //used for setting the width via constraint

    /**
        Allows you to generate a cell without dequeueing one from a table view.
        - Returns: The cell loaded from its nib file.
    */
    class func fromNib() -> LabelCollectionViewCell?
    {
        var cell: LabelCollectionViewCell?
        let nibViews = Bundle.main.loadNibNamed("LabelCollectionViewCell", owner: nil, options: nil)
        for nibView in nibViews! {
            if let cellView = nibView as? LabelCollectionViewCell {
                cell = cellView
            }
        }
        return cell
    }
    
    /**
        Sets the cell styles and content.
    */
    func configureWithIndexPath(indexPath: IndexPath, selectedItem : Int, followUp : String) {
        
        layer.borderWidth  = 1
        layer.cornerRadius = 12
        layer.borderColor  = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6).cgColor
        label.text = followUp
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        
        if indexPath.item == selectedItem {
            
            layer.borderColor = UIColor(red: 0.80, green: 0.07, blue: 0.21, alpha: 1).cgColor
            label.textColor =  UIColor(red: 0.80, green: 0.07, blue: 0.21, alpha: 1)
        }
        
        label.preferredMaxLayoutWidth = 50
    }
}
