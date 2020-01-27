//
//  MainViewController.swift
//  LGSideMenuControllerDemo
//

import UIKit
import LGSideMenuController

class MainViewController: LGSideMenuController {

    private var type: UInt?
    
    func setup(type: UInt) {
        self.type = type

        // -----

        if (storyboard != nil)
        {
            // Left and Right view controllers is set in storyboard
            // Use custom segues with class "LGSideMenuSegue" and identifiers "left" and "right"

            // Sizes and styles is set in storybord
            // You can also find there all other properties

            // LGSideMenuController fully customizable from storyboard
        }
        else
        {
            leftViewController = LeftViewController()

            leftViewWidth = 280.0
//            leftViewBackgroundImage = UIImage(named: "imageLeft")
//            leftViewBackgroundColor = UIColor(red: 0.5, green: 0.65, blue: 0.5, alpha: 0.95)
//            rootViewCoverColorForLeftView = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.05)
        }

        // -----

//        let greenCoverColor = UIColor(red: 0.0, green: 0.1, blue: 0.0, alpha: 0.3)
        let regularStyle: UIBlurEffectStyle

        if #available(iOS 10.0, *)
        {
            regularStyle = .regular
        }
        else
        {
            regularStyle = .light
        }

        // -----

        switch type {
        case 0:
            leftViewPresentationStyle = .slideAbove
//            rootViewCoverColorForLeftView = greenCoverColor
            break
        case 1:
            leftViewPresentationStyle = .slideAbove
            leftViewBackgroundBlurEffect = UIBlurEffect(style: regularStyle)
            leftViewBackgroundColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.05)
//            rootViewCoverColorForLeftView = greenCoverColor

            break
        case 2:
            leftViewPresentationStyle = .slideBelow
//            rootViewCoverColorForLeftView = greenCoverColor

            break
        default:
            break
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    

    override func leftViewWillLayoutSubviews(with size: CGSize) {
        super.leftViewWillLayoutSubviews(with: size)

        if !isLeftViewStatusBarHidden {
            leftView?.frame = CGRect(x: 0.0, y: 20.0, width: size.width, height: size.height - 20.0)
        }
    }
    
    override var isLeftViewStatusBarHidden: Bool {
        get {
            if (type == 8) {
                return UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) && UI_USER_INTERFACE_IDIOM() == .phone
            }

            return super.isLeftViewStatusBarHidden
        }

        set {
            super.isLeftViewStatusBarHidden = newValue
        }
    }

    deinit {
        print("MainViewController deinitialized")
    }

}
