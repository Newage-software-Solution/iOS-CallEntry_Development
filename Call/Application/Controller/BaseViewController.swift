//
//  BaseViewController.swift
//  FrieghtSystem
//
//  Created by Susena on 12/04/17.
//  Copyright © 2017 Hakunamatata solution (P) Ltd. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    // MARK:- Static String Keys -
    
    
    // MARK:- Properties -
    
    
    var loader: DGActivityIndicatorView?
    var viewForLoader: UIView?
    
    let screenBounds = UIScreen.main.bounds
    
    // MARK:- View Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver( self, selector: #selector(BaseViewController.tokenExpireMethod), name: NSNotification.Name(rawValue: "badToken"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.removeLoader), name: NSNotification.Name(rawValue: "NoInternet"), object: nil)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- BUSINESS LOGICS -

    // Get View Controller Instance

    func getViewControllerInstance(storyboardName: String, storyboardId: String) -> AnyObject {
        
        let storyboard  = UIStoryboard(name: storyboardName, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: storyboardId)
        
        return viewController;
    }

    func isReachable() -> NSError? {
        
        if Reachability.isConnectedToNetwork()
        {
            return nil
        }
        else
        {
            let dict = NSDictionary(objects: [AlertMessages.Message.internetAlert], forKeys: [NSLocalizedDescriptionKey as NSCopying])
            
            print("Unable to connect internet")
            
            return NSError(domain: "", code: 600, userInfo: dict as [NSObject : AnyObject])
        }
    }
    
    //Alert messages
    func showAlertMessage(message : String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let retry = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Ok Pressed")
        }
        alertController.addAction(retry)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //Show location mantatory alert
    func showLocationFailureAlert() {
        let alertController = UIAlertController(title: AlertMessages.Message.locationAlertMsg, message: "", preferredStyle: .alert)
        let history = UIAlertAction(title: "Settings", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog(" Setting")
            UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString)! as URL)
            
        }
        let retry = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        alertController.addAction(history)
        alertController.addAction(retry)
        self.present(alertController, animated: true, completion: nil)
    }
    
        /*
     *WriteMethodForBadToken
     */
    
    func tokenExpireMethod() {
        
        
        
    }
    

    //call functionality
    func call(number : String) {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            showAlertMessage(message: "Cant Make call via iPad")
            
        } else {
            
            let numbers = number.removingWhitespaces()
            
            if let url = URL(string: "tel://\(numbers)") {
                
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func mail(email : String) {
        
        if let url = URL(string: "mailto:\(email)") {
            if #available(iOS 10.0, *) {
                
                UIApplication.shared.open(url)
            } else {
                
                UIApplication.shared.openURL(url)
            }
        }
    }
   
    // email validation
    func isValidEmail(emailAddress : String) -> Bool {
        
        let regex = try? NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$", options: .caseInsensitive)
        return regex?.firstMatch(in: emailAddress, options: [], range: NSMakeRange(0, emailAddress.characters.count)) != nil
    }
    
    //mobileNumber Validation
    func isValidMobileNumber(mobileNo : String) -> Bool {
        
        if mobileNo.characters.count >= 8 && mobileNo.characters.count <= 9
        {
            return true
        }
        return false
    }
    
    
    
    func powerNumber(no:String , baseFont : UIFont , superFont: UIFont ,location : Int) -> NSMutableAttributedString {

        let attString:NSMutableAttributedString = NSMutableAttributedString(string: no, attributes: [NSFontAttributeName:baseFont])
        attString.setAttributes([NSFontAttributeName:superFont,NSBaselineOffsetAttributeName:6], range: NSRange(location: location,length:1))

        return attString
    }
    
    
    //Animation Methods
    
    func createBezierPath(fromPoint: CGPoint, toPoint:CGPoint, isDottedLine: Bool, strokeColor: UIColor, animatePath: Bool) -> CAShapeLayer {
        
        let linePath = UIBezierPath()
        linePath.move(to: fromPoint)
        linePath.addLine(to: toPoint)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = linePath.cgPath
        
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineCap = kCALineCapButt
        shapeLayer.strokeColor = strokeColor.cgColor
        
        if isDottedLine
        {
            shapeLayer.strokeColor = strokeColor.cgColor
            shapeLayer.lineDashPattern = [4, 2]
            
            if animatePath
            {
                let animatePhase = CABasicAnimation(keyPath: "lineDashPhase")
                //        animatePhase.byValue = 200
                animatePhase.fromValue = 200
                animatePhase.toValue = 0
                animatePhase.duration = 5
                animatePhase.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
                animatePhase.repeatCount = .infinity
                shapeLayer.add(animatePhase, forKey: "AnimateDottedLine")
            }

        }
        
        //        let totalDashLength = (line.lineDashPattern! as [AnyObject] as NSArray).value(forKeyPath: "@sum.self")
        
        return shapeLayer
        
    }
    
    
    func heightForView(text:String, font: UIFont, width: CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }

    func getTableViewEmptyBackgroundLable(lableText : String) -> UILabel {
        
        let lblHeight = self.heightForView(text: lableText, font: UIFont(name: AvenirFont.avenirBook.rawValue, size: 15.0)!, width: screenBounds.width - 100)
        
        let  messageLabel = UILabel(frame: CGRect(x: 50, y: 0, width: screenBounds.width - 100, height: lblHeight))
        messageLabel.text = lableText
        messageLabel.font = UIFont(name: AvenirFont.avenirBook.rawValue, size: 15.0)
        messageLabel.textColor = UIColor.black
        messageLabel.alpha = 1
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = NSTextAlignment.center
        messageLabel.backgroundColor = .clear
        
        return messageLabel
    }


    
}

// Custom Loader

extension BaseViewController {
    
    // Loader
    func showLoader() {
        view.endEditing(true)
        removeLoader()
        
        viewForLoader = UIView()
        loader = DGActivityIndicatorView(type: DGActivityIndicatorAnimationType.ballClipRotate, tintColor: UIColor(red: 254.0/255.0, green: 242.0/255.0, blue: 0.0, alpha: 1.0))
        let lblLoader = UILabel()
        let width = screenBounds.width / 1.5
        let height = screenBounds.height / 1.5
        loader?.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        loader?.center = view.center
        loader?.tintColor = UIColor(rgb: 0x9999ff).withAlphaComponent(1)
        
        viewForLoader!.frame = screenBounds
        viewForLoader!.isHidden = false
        viewForLoader!.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.35)

        let appDelegate =  UIApplication.shared.delegate as? AppDelegate
        appDelegate?.window?.addSubview(viewForLoader!)
        
        viewForLoader!.addSubview(loader!)
        viewForLoader!.addSubview(lblLoader)
        viewForLoader!.isHidden = false
        loader?.startAnimating()
    }
    
    func removeLoader() {
        
        if let loaderView = viewForLoader
        {
            loaderView.removeFromSuperview()
            loaderView.isHidden = true
        }
    }

}


