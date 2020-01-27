//
//  HMTextView.swift
//  LIAD
//
//  Created by Gowtham on 10/03/16.
//  Copyright © 2016 hakuna. All rights reserved.
//

import UIKit


/**
 *
 * Class:- HMTextView
 *
 * Author:- Hakunamatata Solutions Pvt
 *
 * Updated:- Date 10/03/16
 *
 * Version:- 1.0
 *
 * Discussion:-  This class is used to set placeholder text for TextView with placeholder color. Can edit in attribute inspector
 *
 */


@IBDesignable
public class HMTextView: UITextView {
    
    //    private struct Constants {
    //        static
    //
    //    }
    
    static let defaultPlaceholderColor = UIColor.lightGray
    var maxCharCount = 300
    
    private let placeholderLabel: UILabel = UILabel()
    
    private var placeholderLabelConstraints = [NSLayoutConstraint]()
    
    @IBInspectable var placeholder: String = "" {
        didSet {
            placeholderLabel.text = placeholder
        }
    }
    
    @IBInspectable var placeholderColor: UIColor = defaultPlaceholderColor {
        didSet {
            placeholderLabel.textColor = placeholderColor
        }
    }
    
    override public var font: UIFont! {
        didSet {
            placeholderLabel.font = font
        }
    }
    
    override public var textAlignment: NSTextAlignment {
        didSet {
            placeholderLabel.textAlignment = textAlignment
        }
    }
    
    override public var textColor : UIColor! {
        didSet {
            super.textColor = UIColor.black
        }
    }
    
    override public var text: String! {
        didSet {
            textDidChange()
        }
    }
    
    override public var attributedText: NSAttributedString! {
        didSet {
            textDidChange()
        }
    }
    
    override public var textContainerInset: UIEdgeInsets {
        didSet {
            updateConstraintsForPlaceholderLabel()
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        
        self.autocapitalizationType = .sentences

        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(textDidChange),
                                                         name: NSNotification.Name.UITextViewTextDidChange,
                                                         object: nil)
        
        placeholderLabel.font = font
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.textAlignment = textAlignment
        placeholderLabel.text = placeholder
        placeholderLabel.numberOfLines = 0
        placeholderLabel.backgroundColor = UIColor.clear
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeholderLabel)
        updateConstraintsForPlaceholderLabel()
    }
    
    private func updateConstraintsForPlaceholderLabel() {
        var newConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(\(textContainerInset.left + textContainer.lineFragmentPadding))-[placeholder]",
                                                                            options: [],
                                                                            metrics: nil,
                                                                            views: ["placeholder": placeholderLabel])
        newConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(\(textContainerInset.top))-[placeholder]",
                                                                         options: [],
                                                                         metrics: nil,
                                                                         views: ["placeholder": placeholderLabel])
        newConstraints.append(NSLayoutConstraint(
            item: placeholderLabel,
            attribute: .width,
            relatedBy: .equal,
            toItem: self,
            attribute: .width,
            multiplier: 1.0,
            constant: -(textContainerInset.left + textContainerInset.right + textContainer.lineFragmentPadding * 2.0)
            ))
        removeConstraints(placeholderLabelConstraints)
        addConstraints(newConstraints)
        placeholderLabelConstraints = newConstraints
    }
    
    @objc private func textDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        placeholderLabel.preferredMaxLayoutWidth = textContainer.size.width - textContainer.lineFragmentPadding * 2.0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                            name: NSNotification.Name.UITextViewTextDidChange,
                                                            object: nil)
    }
    
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        
        DispatchQueue.main.async {
            textView.selectAll(nil)
        }
        
        return true
    }
    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        let language = textView.textInputMode?.primaryLanguage
        
        if language == nil
        {
            return false
            
        }
        

        let newString = (textView.text as NSString).replacingCharacters(in: range, with: text)
        
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        if newString.characters.count > maxCharCount {
            return false
        }
        
        return textView.textInputMode != nil
    }
    
}


