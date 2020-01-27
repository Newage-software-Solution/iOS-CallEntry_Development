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
            let dict = NSDictionary(objects: [AlertMessages.Message.checkInternetConnection], forKeys: [NSLocalizedDescriptionKey as NSCopying])
            
            print("Unable to connect internet")
            
            return NSError(domain: "", code: 600, userInfo: dict as? [String : Any])
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
//        let alertController = UIAlertController(title: AlertMessages.Message.locationAlertMsg, message: "", preferredStyle: .alert)
//        let history = UIAlertAction(title: "Settings", style: UIAlertActionStyle.default) {
//            UIAlertAction in
//            NSLog(" Setting")
//            UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString)! as URL)
//
//        }
//        let retry = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
//            UIAlertAction in
//            NSLog("Cancel Pressed")
//        }
//        alertController.addAction(history)
//        alertController.addAction(retry)
//        self.present(alertController, animated: true, completion: nil)
    }
    
        /*
     *WriteMethodForBadToken
     */
    
    @objc func tokenExpireMethod() {
        
        
        
    }
    
   // get indexPath from selected components in cell
    
    func getIndexPath(sender: AnyObject,tbleView: UITableView) -> IndexPath
    {
        let position = sender.convert(CGPoint.zero, to: tbleView)
        let indexPath = tbleView.indexPathForRow(at: position)!
        return indexPath
    }

    //call functionality
    func call(number : String) {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            showAlertMessage(message: "Cant Make call via iPad")
            
        } else {
            
            let numbers = number.removingWhitespaces()
            
            if let url = URL(string: "tel://\(numbers)") {
                
                UIApplication.shared.canOpenURL(url)
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
        return regex?.firstMatch(in: emailAddress, options: [], range: NSMakeRange(0, emailAddress.count)) != nil
    }
    
    //mobileNumber Validation
    func isValidMobileNumber(mobileNo : String) -> Bool {
        
        let PHONE_REGEX = "^(?:(?:\\+|0{0,2})91(\\s*[\\-]\\s*)?|[0]?)?[789]\\d{9}$"  //"^((\\+)|(00))[0-9]{6,14}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: mobileNo)
        
        return result
        
//        if mobileNo.count >= 8 && mobileNo.count <= 9
//        {
//            return true
//        }
//        return false
    }
    
  // Phone Calling
    func phoneCalling(phoneNo: String)
    {
        if let phoneCallURL:URL = URL(string: "tel:\(phoneNo)")
        {
            let application:UIApplication = UIApplication.shared
            
            if (application.canOpenURL(phoneCallURL))
            {
                application.canOpenURL(phoneCallURL)
            }
        }
    }
    
    
    
    func powerNumber(no:String , baseFont : UIFont , superFont: UIFont ,location : Int) -> NSMutableAttributedString {

        let attString:NSMutableAttributedString = NSMutableAttributedString(string: no, attributes: [NSAttributedStringKey.font:baseFont])
        attString.setAttributes([NSAttributedStringKey.font:superFont,NSAttributedStringKey.baselineOffset:6], range: NSRange(location: location,length:1))

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
        
        let lblHeight = self.heightForView(text: lableText, font: UIFont(name: AvenirFont.avenirRoman.rawValue, size: 15.0)!, width: screenBounds.width - 100)
        
        let  messageLabel = UILabel(frame: CGRect(x: 50, y: 0, width: screenBounds.width - 100, height: lblHeight))
        messageLabel.text = lableText
        messageLabel.font = UIFont(name: AvenirFont.avenirRoman.rawValue, size: 15.0)
        messageLabel.textColor = UIColor.black
        messageLabel.alpha = 1
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = NSTextAlignment.center
        messageLabel.backgroundColor = .clear
        
        return messageLabel
    }

    func showBottomAlert(message : String) {
        
        let sb = Snackbar()
        sb.sbLenght = .long
        sb.createWithAction(text: NSLocalizedString(message, comment: ""), actionTitle: "",
                            action: {
                                //print("Button is push")
        })
        sb.show()
    }
    
    func showBottomAlertWithGreenBG(message : String) {
        
        let sb = Snackbar()
        sb.sbLenght = .long
        sb.backgroundColor = UIColor(red: (141/255), green: (196/255), blue: (82/255), alpha: 1.0)
        sb.createWithAction(text: NSLocalizedString(message, comment: ""), actionTitle: "",
                            action: {
                                //print("Button is push")
        })
        sb.show()
    }
    
    
    func getTheCurrentDate() -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
    func getTheCurrentDateWithFormat(dateFormat : String) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter.string(from: Date())
    }
}

// Custom Loader

extension BaseViewController {
    
    func showLoader() {
        
        view.endEditing(true)
        self.removeLoader()
        loader = DGActivityIndicatorView(type: DGActivityIndicatorAnimationType.ballClipRotate ,tintColor:UIColor.white)
        
        let width  = UIScreen.main.bounds.width / 5.0
        let height = UIScreen.main.bounds.height / 7.0
        
        loader?.frame = CGRect(x: (UIScreen.main.bounds.width / 2) - (width / 2), y: (UIScreen.main.bounds.height / 2) - (height / 2), width: width, height: height)
        //CGRect((UIScreen.main.bounds.width / 2) - (width / 2), (UIScreen.main.bounds.height / 2) - (height / 2), width, height)
        loader?.center = view.center
        
        loader?.startAnimating()
        
        let tempWindow : UIWindow? = UIApplication.shared.delegate?.window!
        tempWindow?.isUserInteractionEnabled = false
        viewForLoader = UIView(frame: CGRect(x: 0, y: 0, width: (tempWindow?.bounds.width)!, height: (tempWindow?.bounds.height)!))
        viewForLoader?.alpha = 0.4
        //viewForLoader?.center = (loader?.center)!
        viewForLoader?.backgroundColor = UIColor.black
        viewForLoader?.addSubview(loader!)
        
        tempWindow?.addSubview(viewForLoader!)
        //tempWindow?.addSubview(loader!)
    }
    
    
    @objc func removeLoader() {
        
        let tempWindow : UIWindow? = UIApplication.shared.delegate?.window!
        tempWindow?.isUserInteractionEnabled = true
        //loader?.removeFromSuperview()
        viewForLoader?.removeFromSuperview()
        viewForLoader = nil
        //loader = nil
    }
    
    /*
    // Loader
    func showLoader() {
        view.endEditing(true)
        removeLoader()
        
        loader = DGActivityIndicatorView(type: DGActivityIndicatorAnimationType.ballClipRotate, tintColor: UIColor(red: 254.0/255.0, green: 242.0/255.0, blue: 0.0, alpha: 1.0))
        //let lblLoader = UILabel()
        let width = screenBounds.width / 1.5
        let height = screenBounds.height / 1.5
        
        loader?.frame = CGRect(x: 0, y: 0, width: width, height: height)
        loader?.tintColor = UIColor(rgb: 0x9999ff).withAlphaComponent(1)
        
        loader?.startAnimating()
        
        loader?.center = view.center
        
        
        viewForLoader = UIView()
        viewForLoader!.frame = screenBounds
        viewForLoader!.isHidden = false
        viewForLoader!.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.35)

        let appDelegate =  UIApplication.shared.delegate as? AppDelegate
        appDelegate?.window?.addSubview(viewForLoader!)
        
        viewForLoader!.addSubview(loader!)
        //viewForLoader!.addSubview(lblLoader)
        viewForLoader!.isHidden = false
    }
    
    @objc func removeLoader() {
        
        if let loaderView = viewForLoader
        {
            loaderView.removeFromSuperview()
            loaderView.isHidden = true
        }
    }
 */

}


