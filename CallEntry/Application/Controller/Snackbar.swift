//
//  Snackbar.swift
//  snackbar
//
//  Created by Нейкович Сергей on 30.11.16.
//  Copyright © 2016 CubInCup. All rights reserved.
//

import UIKit

enum SBAnimationLength {
    case shot
    case long
}

class Snackbar: NSObject {
    
    // settings snackbar
    var snackbarHeight: CGFloat     = 70
    var backgroundColor: UIColor    = UIColor(red: (203/255), green: (17/255), blue: (53/255), alpha: 1.0)//UIColor(red: (254/255), green: (80/255), blue: (80/255), alpha: 1.0)
    var textColor: UIColor          = .white
    var buttonColor:UIColor         = .cyan
    var buttonColorPressed:UIColor  = .gray
    var sbLenght: SBAnimationLength = .shot
    
    //private variables
    private let window = UIApplication.shared.keyWindow!
    private let snackbarView = UIView(frame: .zero)
    
    private let txt: UILabel = UILabel()
    private let btn: UIButton = UIButton()
    
    private var action: (() -> Void)? = nil
    
    
    override init(){
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(rotate), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    /// Show simple text notification
    open func createWithText(_ text: String) {
        
        setupSnackbarView()
        
        txt.numberOfLines = 0
        txt.text = text
        txt.textColor = textColor
        txt.font = UIFont(name: "Montserrat-Regular", size: 16.0)
        txt.frame = CGRect(x: window.frame.width * 5/100, y: 0, width: window.frame.width * 95/100, height: snackbarHeight)
        snackbarView.addSubview(txt)
        
        show()
    }
    
    
    /// Show snackbar with text and button
    open func createWithAction( text: String, actionTitle: String, action: @escaping () -> Void){
        self.action = action
        
        setupSnackbarView()
        
        txt.numberOfLines = 0
        txt.text = text
        txt.textColor = textColor
        txt.numberOfLines = 0
        txt.frame = CGRect(x: window.frame.width * 5/100, y: 0, width: window.frame.width * 75/100, height: snackbarHeight)
        snackbarView.addSubview(txt)
        
        //btn.setTitleColor(buttonColor,  for: .normal)
        //btn.setTitleColor(.gray, for: .highlighted)
        //btn.setTitle(actionTitle, for: .normal)
        btn.setImage(UIImage(named: "Reg_Close_White"), for: .normal)
        btn.addTarget(self, action: #selector(actionButtonPress), for: .touchUpInside)
        btn.frame = CGRect(x: window.frame.width * 78/100, y: 0, width: window.frame.width * 25/100, height: snackbarHeight)//73 - x-po multiply
        
        snackbarView.addSubview(btn)
        
        show()
    }
    
    
    
    open func show(){
        switch sbLenght {
        case .shot:
            animateBar(2)
            
        case .long:
            animateBar(3)
            
        }
    }
    
    
    private func setupSnackbarView(){
        
        snackbarView.removeFromSuperview()
        window.addSubview(snackbarView)
        
        snackbarView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: snackbarHeight)
        snackbarView.backgroundColor = self.backgroundColor
    }
    
    
    
    fileprivate func animateBar(_ timerLength: Float){
        
        UIView.animate(withDuration: 0.4, animations: {
            self.snackbarView.frame = CGRect(x: 0, y: self.window.frame.height - self.snackbarHeight, width: self.window.frame.width, height: self.snackbarHeight)
            
            Timer.scheduledTimer(timeInterval: TimeInterval(timerLength), target: self, selector: #selector(self.hide), userInfo: nil, repeats: false)
        })
    }
    
    
    // MARK: Selectors
    
    @objc private func actionButtonPress(){
        action!()
        hide()
    }
    
    @objc private func hide(){
        UIView.animate(withDuration: 0.4, animations: {
            self.snackbarView.frame = CGRect(x: 0, y: self.window.frame.height, width: self.window.frame.width, height: self.snackbarHeight)
         })
    }
    
    @objc private func rotate(){
        self.snackbarView.frame = CGRect(x: 0, y: self.window.frame.height - self.snackbarHeight, width: self.window.frame.width, height: self.snackbarHeight)
        btn.frame = CGRect(x: window.frame.width * 73/100, y: 0, width: window.frame.width * 25/100, height: snackbarHeight)
    }
    
}


