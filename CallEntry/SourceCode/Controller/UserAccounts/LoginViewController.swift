 //
//  LoginViewController.swift
//  CallEntry
//
//  Created by Rajesh on 07/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

class LoginViewController: ComponentIntendationViewController {
    
    // MARK:- View Static Variables -
    let minimumPasswrodCharCount: Int = 5
    
    // MARK:- IBOutlets -
    @IBOutlet weak var bottomConstraintForScrollView: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var heightConstraintForContentView: NSLayoutConstraint!
    
    @IBOutlet weak var btnRememberMe: UIButton!
    @IBOutlet weak var textFieldUserName: UITextField!
    
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    var isMasterDataRecd: Bool = false
    var isPortDataReceived: Bool = false
    var isCustomerListReceived: Bool = false

    // MARK:- Properties -
    
    let model = UserAccountModel()
    
    // MARK:- View Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.delegate = self

        self.navigationController?.isNavigationBarHidden = true
        btnLogin.layer.cornerRadius = 14.0
        btnLogin.layer.borderWidth = 2.0
        btnLogin.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        loadComponentIndentData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Check whether the user is logged in or not.
        
        if UserDefaultModel.isUserDefaultHasValue(forKey: UIConstants.UserDefaultKey.userInfo)
        {
            if let loginDetail =  UserDefaultModel.getUserInfo()
            {
                AppCacheManager.sharedInstance().userId = loginDetail.userid
                AppCacheManager.sharedInstance().authToken = loginDetail.usertoken
                AppCacheManager.sharedInstance().userDetail = loginDetail.userdetail
                AppCacheManager.sharedInstance().salesmanCode = loginDetail.empcode
//                AppCacheManager.sharedInstance().isManager = loginDetail.ismanager
                AppCacheManager.sharedInstance().isManager  = "N"
            }

            getAppRequiredData()
        }
        else
        {
            configureViewData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- BUSINESS LOGICS -
    
    func configureViewData() {

        //Check if any rememberd user info is there are not
        if let rememberedUserInfo = UserDefaultModel.getRememberedUser()
        {
            textFieldUserName.text = rememberedUserInfo.username
            textFieldPassword.text = rememberedUserInfo.password
            
            btnRememberMe.isSelected = true
        }
        else
        {
            textFieldUserName.text = ""
            textFieldPassword.text = ""
            btnRememberMe.isSelected = false
        }
        
    }
    
    func loadComponentIndentData() {
        
        self.scrollViewBottomConstraintBase = bottomConstraintForScrollView
        self.scrollViewOutletBase = scrollView
        
        if heightConstraintForContentView.constant < CGFloat(screenBounds.height - 65.0)// 65.0 header height
        {
            heightConstraintForContentView.constant = CGFloat(screenBounds.height + 20)
        }
    }

    func isValidationSuccess() -> Bool {
        
        if textFieldUserName.text == ""
        {
            self.showAlertMessage(message: AlertMessages.Message.enterUserName)
            return false
        }
  
        
        if textFieldPassword.text == ""
        {
            self.showAlertMessage(message: AlertMessages.Message.enterPassword)
            return false
        }
        else
        {
            if textFieldPassword.text!.count < minimumPasswrodCharCount
            {
                self.showAlertMessage(message: AlertMessages.Message.invalidPassword)
                return false
            }
        }
        
        return true
    }
    
    func generateRequest() -> LoginRequest {
        
        let request = LoginRequest()
        request.username = textFieldUserName.text!
        request.password = textFieldPassword.text!
        return request
    }
    
    func generateMasterDataRequest() -> GetMasterDataRequest {
        
        let request = GetMasterDataRequest()
        request.userid = AppCacheManager.sharedInstance().userId
        request.usertoken = AppCacheManager.sharedInstance().authToken

        return request
    }
    
    func generatePortDataRequest() -> GetPortDataRequest {
        
        let request = GetPortDataRequest()
        request.userid = AppCacheManager.sharedInstance().userId
        request.usertoken = AppCacheManager.sharedInstance().authToken
        
        return request
    }
    
    func generateCustomerListRequest() -> CustomerListRequest {
        
        let request = CustomerListRequest()
        request.userid = AppCacheManager.sharedInstance().userId
        request.usertoken = AppCacheManager.sharedInstance().authToken
        
        if CustomerListDB.fetchCustomerList().count > 0 {
            
            request.updateddata = "Y"
            
            if let date = UserDefaultModel.getLastModifiedDate()
            {
            request.lastmodifieddate = date.dateToString(outputFormat: DateFormatConstant.regularFormat)
            }
            else
            {
            request.lastmodifieddate = Date().dateToString(outputFormat: DateFormatConstant.regularFormat)
            }
            
        }
        else {
            request.updateddata = "N"
            //request.lastmodifieddate = Date().dateToString(outputFormat: DateFormatConstant.regularFormat)
            
        }
        
       
        
        return request
    }
    

    func updateRememberedUser() {
        
        if btnRememberMe.isSelected
        {
            //Save Recent User in UserDefault
            UserDefaultModel.updateRememberedUser(request: generateRequest())
        }
        else
        {
            //remove Recent User in UserDefault
            UserDefaultModel.removeUserDefaultValue(forKey: UIConstants.UserDefaultKey.rememberedUserInfo)
        }
    }
    
    
    func navigateToDashboard() {
        
        if isMasterDataRecd && isPortDataReceived && isCustomerListReceived
        {
            self.removeLoader()

            let storyboard = UIStoryboard(name: StoryBoardID.sideMenu.rawValue, bundle: nil)
            let navigationController = storyboard.instantiateViewController(withIdentifier: ViewControllerID.navigationController.rawValue) as! UINavigationController
            
            let mainStoryboard =  UIStoryboard(name: StoryBoardID.dashboard.rawValue, bundle: nil)
            
            navigationController.setViewControllers([mainStoryboard.instantiateViewController(withIdentifier: ViewControllerID.dashboardViewController.rawValue)], animated: false)
            
            let mainViewController = storyboard.instantiateInitialViewController() as! MainViewController
            mainViewController.rootViewController = navigationController
            mainViewController.setup(type: UInt(2))
            mainViewController.rootViewStatusBarStyle = .lightContent
            
            self.navigationController?.pushViewController(mainViewController, animated: true)
        }

       
    }
    
    func getAppRequiredData() {
      
        isMasterDataRecd = false
        isPortDataReceived = false
        isCustomerListReceived = false
        self.showLoader()
        
        model.getMasterData(request: generateMasterDataRequest())
        
        model.getPortData(request: generatePortDataRequest())

        model.getCustomerList(request: generateCustomerListRequest())

    }

    //MARK:- BUTTON ACTIONS -
    
    @IBAction func rememberMeButtonAction(_ sender: UIButton) {
       
        if sender.isSelected
        {
            sender.isSelected = false
        }
        else
        {
            sender.isSelected = true
        }
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        
        if isValidationSuccess()
        {
            updateRememberedUser()
            
            self.showLoader()
            model.submitLoginDetails(request: generateRequest())
        }
    }
    
    @IBAction func forgotPasswordButtonAction(_ sender: Any) {
        
        let forgetViewController = getViewControllerInstance(storyboardName: StoryBoardID.userAccount.rawValue, storyboardId: ViewControllerID.forgorPasswordViewController.rawValue) as! ForgotPasswordViewController
     //   forgetViewController.delegate = self
        self.navigationController?.pushViewController(forgetViewController, animated: true)
    }
}

// MARK:- Delegate Methods -

extension LoginViewController: UserAccountModelDelegate {
    
    func employeeListReceived(response: [EmployeeDetail]) {
        //optional method
    }
    func changePassword(message: String) {
        //
    }
    
    func masterDataReceived() {
        print("masterDataReceived")
        isMasterDataRecd = true
       
        navigateToDashboard()
    }
    
    func portDataReceived() {
        print("portDataReceived")
        isPortDataReceived = true
       
        navigateToDashboard()
    }
    
    func customerListReceived() {
        print("customerListReceived")
        isCustomerListReceived = true
        
        UserDefaultModel.updateLastModifiedDate()
        
        navigateToDashboard()
    }
    
    func loginSuccess(response: LoginResponse) {
        print("loginSuccess")
        self.removeLoader()
        getAppRequiredData()
    }
    
    func apiHitFailure() {
        print("apiHitFailure")
        self.removeLoader()
    }
}

 
//MARK:- UITextFieldDelegate Methods-

extension LoginViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == textFieldUserName
        {
            textFieldPassword.becomeFirstResponder()
        }
        else
        {
            textField.resignFirstResponder()
        }
        
        return false
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
}

