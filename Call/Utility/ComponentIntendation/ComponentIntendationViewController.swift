//
//  ComponentIntendationViewController.swift
//  LIAD
//
//  Created by Gowtham on 31/05/16.
//  Copyright © 2016 hakuna. All rights reserved.
//

import UIKit

class ComponentIntendationViewController: BaseViewController,UIGestureRecognizerDelegate {
    
    // MARK: - IBOutlets
    

    // MARK: - Properties
    
    var scrollViewBottomConstraintBase = NSLayoutConstraint()
    var textViewCurrentBase : UITextView!
    var scrollViewOutletBase : UIScrollView!
    var scrollPositionBase : CGFloat = 0.0

    var isWhiteSpaceShowing = false
    
    // MARK: - ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ComponentIntendationViewController.dismissKeyboard(_ :)))
        tapGesture.delegate = self
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Business Logic
    
    func dismissKeyboard(_ sender: UITapGestureRecognizer) {
//        print("tapped")
        if sender.state == .ended {
//            print("end editing")
            self.view.endEditing(true)
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        return touch.view!.isDescendant(of: gestureRecognizer.view!)
    }


  func registerForKeyboardNotifications() {
    
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self, selector: #selector(self.keyboardWillBeShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    notificationCenter.addObserver(self, selector: #selector(self.keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    
    }
    
    func keyboardWillBeShown(sender : NSNotification) {
        
        let keyboardSize = (sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        
        if textViewCurrentBase != nil
        {
            if let contentOff = self.scrollViewOutletBase?.contentOffset
            {
                // println(contentOff)
                
                var txtViewFrame =  self.textViewCurrentBase!.superview?.convert(self.textViewCurrentBase!.frame.origin, to: self.view)
                
                if contentOff.y != 0.0
                {
                    var addYValue = txtViewFrame
                    addYValue!.y += contentOff.y
                    txtViewFrame = addYValue
                }
                
                let txtViewHeight = self.textViewCurrentBase!.frame.size.height
                var txtViewVisible = txtViewFrame
                txtViewVisible!.y += txtViewHeight
                var visibleRect = self.view.frame
                visibleRect.size.height -= keyboardSize!.height
                
                if !(visibleRect.contains(txtViewVisible!))
                {
                    if txtViewFrame!.y > visibleRect.size.height
                    {
                        let scrollPoint = CGPoint(x: 0.0, y: txtViewFrame!.y - visibleRect.size.height + txtViewHeight)
                        self.scrollViewOutletBase!.setContentOffset(scrollPoint, animated: true)
                    }
                    else
                    {
                        let scrollPoint = CGPoint(x:0.0, y: visibleRect.size.height - txtViewFrame!.y + txtViewHeight)
                        self.scrollViewOutletBase!.setContentOffset(scrollPoint, animated: true)
                    }
                }

            }
        }
        
        textViewCurrentBase = nil
        
        if isWhiteSpaceShowing
        {
            scrollViewBottomConstraintBase.constant = keyboardSize!.height - 50.0
        }
        else
        {
            scrollViewBottomConstraintBase.constant = keyboardSize!.height
        }
        
        self.view.layoutIfNeeded()
    }
    
    func keyboardWillBeHidden(sender : NSNotification) {
        
        self.scrollViewBottomConstraintBase.constant = 0.0
        self.view.layoutIfNeeded()
    }
    
}


// MARK: - Delegate Methods


//MARK:- UIScrollViewDelegate Delegates

extension ComponentIntendationViewController : UIScrollViewDelegate  {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollPositionBase = scrollView.contentOffset.y
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let different = scrollView.contentOffset.y - scrollPositionBase
        
        if different < -20
        {
            self.view.endEditing(true)
        }
    }
    
}
