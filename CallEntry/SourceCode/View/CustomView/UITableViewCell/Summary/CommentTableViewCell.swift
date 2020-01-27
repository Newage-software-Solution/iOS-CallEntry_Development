//
//  CommentTableViewCell.swift
//  CallEntry
//
//  Created by HMSPL on 19/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

@objc protocol CommentTableViewCellDelegates {
    
    @objc optional func textViewDidBeginEditing(textView: UITextView)
    @objc optional func txtViewDescription(desc : String)
}


class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var textviewComment: UITextView!
    @IBOutlet weak var lblCharactersCount: UILabel!
    
    var commentDelegate : CommentTableViewCellDelegates?
    
    override func awakeFromNib() {
        
        textviewComment.delegate = self
        if textviewComment.text.isEmpty {
            
            textviewComment.text = "Your Comment"
        }
        super.awakeFromNib()
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}


// TextView Delegate from cell
extension CommentTableViewCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            textviewComment.resignFirstResponder()
            return false
        }
        if textView.text.count + 1 <= 100
        {
            return true
        }
        else
        {
            if text == ""
            {
                return true
            }
            return false
        }
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text.count <= 100 {
            
        self.lblCharactersCount.text = "\(textView.text.count)/100"
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        self.commentDelegate?.textViewDidBeginEditing?(textView: textView)
        if textView.text.count > 0 {
            textView.text = ""
        }
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
     
        self.commentDelegate?.txtViewDescription?(desc: textView.text ?? "")
    }
}

