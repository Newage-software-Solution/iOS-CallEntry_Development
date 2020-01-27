//
//  NewCallEntryViewController.swift
//  CallEntry
//
//  Created by Rajesh on 07/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

class NewCallEntryViewController: ComponentIntendationViewController {
    
    // MARK:- View Static Variables -
    
    // MARK:- IBOutlets -
    
    @IBOutlet weak var bottomConstraintForScrollView: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var heightConstraintForContentView: NSLayoutConstraint!

    @IBOutlet weak var heightConstraintForTextFieldCustomer: NSLayoutConstraint!
    
    @IBOutlet weak var textFieldCustomer: HMSuggestionTextField!
    
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var btnSave: UIButton!
    
    
    @IBOutlet weak var stackViewCusDetail: UIStackView!
    
    @IBOutlet weak var btnNewCustomer: HMRadioButton!
    
    @IBOutlet weak var btnExistingCustomer: HMRadioButton!

    @IBOutlet weak var textFieldCategory: HMCompoField!
    
    @IBOutlet weak var btnVisitMode: HMRadioButton!
    @IBOutlet weak var btnMailMode: HMRadioButton!
    @IBOutlet weak var btnPhoneMode: HMRadioButton!
    
    @IBOutlet weak var textFieldFollowUpDate: HMCompoField!

    @IBOutlet weak var textFieldFollowUpAct: HMCompoField!
    
    @IBOutlet weak var textFieldCallEntryDate: HMCompoField!
    
    @IBOutlet weak var txtViewCallDescription: HMTextView!

    // MARK:- Properties -
    var currentTextField: UITextField!

    var model = CallEntryModel()
    
    var selectedCustomerList: Customerlist!
    
    var isSideMenuNavigation: Bool = true
    
    var callTypeSelected : String = "New"
    var callSubType : String = ""
    var callMode : String = ""
    var followUpdate : String = ""
    var followUpaction : String = ""
    var callEntryDate : String = ""
    
    // MARK:- View Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.delegate = self
        
        self.navigationController?.isNavigationBarHidden = true
       
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MMM/yyyy"
        callEntryDate = formatter.string(from: date)
        self.textFieldCallEntryDate.text = callEntryDate
        loadComponentIndentData()
        configureViewData()
        configureCountryCodeData()
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        sideMenuController?.isLeftViewSwipeGestureEnabled = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        sideMenuController?.isLeftViewSwipeGestureDisabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    //MARK:- BUSINESS LOGICS -
    
    func generateNewCallEntry() -> NewCallEntryRequest {
        var jsonString: String!
        if !(UserDefaults.standard.value(forKey: "SavedStringArray") as! String).elementsEqual("") {
            var dictPassValue = [String:String]()
            let data = Data((UserDefaults.standard.value(forKey: "SavedStringArray") as! String).utf8)
            let json_Data = try! JSONDecoder().decode([JoinCallDataSaving].self, from: data)
            
            for value in json_Data {
                dictPassValue[value.codeSave] = value.descriptSave
            }
            let jsonData = try! JSONEncoder().encode(dictPassValue)
            jsonString = String(data: jsonData, encoding: .utf8)!
            print(jsonString)
        }
        
        let newCallEntryRequest = NewCallEntryRequest()
        
        newCallEntryRequest.user_token = AppCacheManager.sharedInstance().authToken
        newCallEntryRequest.username  = AppCacheManager.sharedInstance().userId
        newCallEntryRequest.cus_code  = selectedCustomerList.custid
        
        //newCallEntryRequest.custid         = selectedCustomerList.custid
        newCallEntryRequest.call_type       = callTypeSelected
        newCallEntryRequest.sub_type        = callSubType
        newCallEntryRequest.call_mode       = callMode
        newCallEntryRequest.desc            = txtViewCallDescription.text
        newCallEntryRequest.follow_date     = followUpdate
        newCallEntryRequest.create_date     = callEntryDate
        newCallEntryRequest.jointcalls      = jsonString
        newCallEntryRequest.follow_action = model.getFollowupActionId(followupAct: AppCacheManager.sharedInstance().masterData.followupaction, name: followUpaction)
        
//        let date = Date()
//
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd/MMM/yyyy"
//        newCallEntryRequest.create_date = formatter.string(from: date)
        
        //newCallEntryRequest.newcallentry = newcallentry
        
        return newCallEntryRequest
    }
    
    
    func configureViewData() {
        
        if isSideMenuNavigation
        {
            btnBack.isHidden = true
            btnMenu.isHidden = false
        }
        else
        {
            btnBack.isHidden = false
            btnMenu.isHidden = true
        }
        
        textFieldCustomer.delegate = self
        textFieldCustomer.textField.returnKeyType = .default
        textFieldCustomer.applyRegex = .none
        textFieldCustomer.suggestionList = AppCacheManager.sharedInstance().customerList as [AnyObject]
        textFieldCustomer.btnAddNew.isHidden = false
        
        textFieldFollowUpDate.pickerType = .ComboDate
        textFieldFollowUpDate.minDate = DateExtension.stringFromDate(date: Date(), dateFormat: "dd/MMM/yyyy")!
        textFieldFollowUpDate.dateformat = "dd/MMM/yyyy"
        textFieldFollowUpDate.pickerDelegate = self
        textFieldFollowUpDate.setDate = String(describing: Date())
        textFieldFollowUpDate.selectedTag = 101
        textFieldFollowUpDate.loadView()
        
        textFieldCallEntryDate.pickerType = .ComboDate
        textFieldCallEntryDate.minDate = DateExtension.stringFromDate(date: DateExtension.generateDateWithGivenDays(date: Date(), days: -3)!, dateFormat:  "dd/MMM/yyyy")!
        textFieldCallEntryDate.dateformat = "dd/MMM/yyyy"
        textFieldCallEntryDate.pickerDelegate = self
        textFieldCallEntryDate.setDate = String(describing: Date())
        textFieldCallEntryDate.selectedTag = 103
        textFieldCallEntryDate.loadView()
        
        btnNewCustomer.isSelected = true
        textFieldCategory.pickerDelegate = self
        var categoryList = model.getSubcategoryListForCategory("NEW") as [AnyObject] as NSArray
        categoryList = categoryList.map({
            ($0 as! String).localizedLowercase
        }) as NSArray
        textFieldCategory.list = categoryList
        textFieldCategory.selectedTag = 100
        textFieldCategory.loadView()

        textFieldFollowUpAct.pickerDelegate = self
        textFieldFollowUpAct.selectedTag = 102
        var list = model.getFollowupAction(followupAct: AppCacheManager.sharedInstance().masterData.followupaction) as [AnyObject] as NSArray
        list = list.map({
            ($0 as! String).localizedLowercase
        }) as NSArray
        print(list)
        textFieldFollowUpAct.list = list
        textFieldFollowUpAct.loadView()
        stackViewCusDetail.isUserInteractionEnabled = false
        stackViewCusDetail.alpha = 0.5
    }
    
    func configureEditData() {
        
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
        
        if selectedCustomerList == nil {
            
            showBottomAlert(message: "Please select the customer")
            return false
        } else if callTypeSelected == "" {
            
            showBottomAlert(message: "Please select the call type")
            return false
        } else if callSubType == "" {
            
            showBottomAlert(message: "Please select the category")
            return false
        } else if callMode == "" {
            
            showBottomAlert(message: "Please select the call mode")
            return false
        } else if txtViewCallDescription.text == "" {
            
            showBottomAlert(message: "Enter Call description")
            return false
        } else if followUpdate == "" {
            
            showBottomAlert(message: "Please select the Plan/followUpdate")
            return false
        } else if followUpaction == "" {
            
            showBottomAlert(message: "Please select the followUp action")
            return false
        } else if callEntryDate == "" {
            showBottomAlert(message: "Please select the call-entry date")
        }
        
        return true
    }
    
    
    //MARK:- BUTTON ACTIONS -
    
    @IBAction func joinCallAction(_ sender: Any) {
        let joinCallViewController = getViewControllerInstance(storyboardName: StoryBoardID.callEntry.rawValue, storyboardId: ViewControllerID.joinCallViewController.rawValue) as! JoinCallViewController
        self.navigationController?.pushViewController(joinCallViewController,animated: true)
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
       
        if isValidationSuccess() {
            self.showLoader()
            model.newCallEntry(request: generateNewCallEntry())
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func profileButtonAction(_ sender: Any) {
        
        if let customerDetail = selectedCustomerList
        {
            let profileDetailViewController = getViewControllerInstance(storyboardName: StoryBoardID.potentialBusiness.rawValue, storyboardId: ViewControllerID.potentialBusinessDetailViewController.rawValue) as! PotentialBusinessDetailViewController
            profileDetailViewController.profiles = customerDetail.profile
            profileDetailViewController.custid = customerDetail.custid
        self.navigationController?.pushViewController(profileDetailViewController, animated: true)
        }
        else
        {
            self.showAlertMessage(message: AlertMessages.Message.selectCustomerToViewProfile)
        }
    }
    
    @IBAction func callHistoryButtonAction(_ sender: Any) {
        
        if let customerDetail = selectedCustomerList
        {
            let callHistoryListViewController = getViewControllerInstance(storyboardName: StoryBoardID.callEntry.rawValue, storyboardId: ViewControllerID.callHistoryListViewController.rawValue) as! CallHistoryListViewController
//            callHistoryListViewController.callHistory = customerDetail.callhistory
            callHistoryListViewController.custId = customerDetail.custid
            
            self.navigationController?.pushViewController(callHistoryListViewController, animated: true)
        }
        else
        {
            self.showAlertMessage(message: AlertMessages.Message.selectCustomerToViewCallHistory)
        }
        
    }
    
    @IBAction func shipmentHistoryButtonAction(_ sender: Any) {
     
        if let customerDetail = selectedCustomerList
        {
            let shipmentHistoryViewController = getViewControllerInstance(storyboardName: StoryBoardID.customer.rawValue, storyboardId: ViewControllerID.shipmentHistoryListViewController.rawValue) as! ShipmentHistoryListViewController
            shipmentHistoryViewController.code = customerDetail.custid
            self.navigationController?.pushViewController(shipmentHistoryViewController, animated: true)
        }
        else
        {
            self.showAlertMessage(message: AlertMessages.Message.selectCustomerToViewLastShipment)
        }
    }
    
  
    @IBAction func customerCategoryButtonAction(_ sender: UIButton) {
        
        if sender.tag == 100
        {
            //New Customer
            callTypeSelected = "New"
            textFieldCategory.list = model.getSubcategoryListForCategory("New") as [AnyObject] as NSArray
        }
        else if sender.tag == 101
        {
            //Existing Customer
            callTypeSelected = "Existing"
            textFieldCategory.list = model.getSubcategoryListForCategory("Existing") as [AnyObject] as NSArray
        }
        
        textFieldCategory.reloadData()
    }
    
    
    @IBAction func btnActCallModeAction(_ sender: HMRadioButton) {
        
       callMode =  sender.tag == 100 ? "Phone" : sender.tag == 101 ? "Mail" : "Visit"
    }
}


// MARK:- Delegate Methods -

//MARK:- CallEntryModelDelegate -

extension NewCallEntryViewController: CallEntryModelDelegate {
    
    func apiHitFailure() {
    }
    
    func newCallEnterDataAddedSuccess() {
        
        self.removeLoader()
        
         AppCacheManager.sharedInstance().reloadDashBoard = true
        if !isSideMenuNavigation {
            
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
        else {
            
            let mainViewController = sideMenuController!
            let navigationController = mainViewController.rootViewController as! NavigationController
            
            let storyboard = UIStoryboard(name: StoryBoardID.dashboard.rawValue, bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: ViewControllerID.dashboardViewController.rawValue)
            navigationController.setViewControllers([viewController], animated: false)
            
            mainViewController.hideLeftView(animated: false, completionHandler: nil)
            
            if  let leftViewController = mainViewController.leftViewController as? LeftViewController {
                
                leftViewController.selectedIndexPath = IndexPath(row: 0, section: 0)
                leftViewController.tableViewLeftMenu.reloadData()
            }
        }

        showBottomAlertWithGreenBG(message: "NewCall Entry data added successfully")
    }
}

//MARK:- UITextViewDelegate -

extension NewCallEntryViewController : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        
        self.textViewCurrentBase = textView 
        self.loadComponentIndentData()
        //bottomConstraintForScrollView.constant = 200
        //self.view.layoutIfNeeded()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        
        if text == "\n" {
            
            textView.resignFirstResponder()
            
        return false
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        self.loadComponentIndentData()
        //bottomConstraintForScrollView.constant = 0
        //self.view.layoutIfNeeded()
    }
    
}

// MARK: - HMPickerDelegate Methods -

extension NewCallEntryViewController: HMPickerDelegate {
    
    func pickerSelected(index : Int, selectedTag : Int,withData : AnyObject) {
        
        if selectedTag == 100 {
            
            callSubType = withData as? String ?? ""
        } else if selectedTag == 101 {
            
            followUpdate = withData as? String ?? ""
        } else if selectedTag == 102 {
            
            followUpaction = withData as? String ?? ""
        } else if selectedTag == 103 {
            callEntryDate = withData as? String ?? ""
        }
    }
}


// MARK: - HMSuggestionTextFieldDelegate Methods -
extension NewCallEntryViewController: HMSuggestionTextFieldDelegate {
    func updateHeightConstraintsHMSuggestion(height: CGFloat, tag: Int) {
        let defaultHeight: CGFloat = 50.0 //Textfield Height + Title Label + View Separator Height
        
        if currentTextField == textFieldCustomer.textField
        {
            heightConstraintForTextFieldCustomer.constant = defaultHeight + height
        }
    }
    
    
    func btnActAddNewClicked() {
        
        let newCustomerViewCtrl = getViewControllerInstance(storyboardName: StoryBoardID.customer.rawValue, storyboardId: ViewControllerID.newCustomerViewController.rawValue) as! NewCustomerViewController
        newCustomerViewCtrl.isEditingTextfield = true
        newCustomerViewCtrl.defaultCustomername = self.textFieldCustomer.textField.text!
        let navCtrl = UINavigationController(rootViewController: newCustomerViewCtrl)
        self.present(navCtrl, animated: true, completion: nil)
    }
    
    func configureCountryCodeData() {
    
        if let jsonData = CodeSnippets.getJsonDataForFile(fileName: "CountryList") //give exact test data json file name
        {
            do
            {
                let response = try JSONDecoder().decode(CountryList.self, from: jsonData)
                AppCacheManager.sharedInstance().countryList = response
            }
            catch (let error)
            {
                print(error.localizedDescription)
            }
        }
        
    }
    
    func suggestionTextFieldDidBeginEditing(_ textField: UITextField){
        
        currentTextField = textField
    }
    
    func suggestionTextFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        textField.resignFirstResponder()
        
        return true
    }
    
    func suggestionTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) {
        
        let stringText = NSString(format: "%@", textField.text!)
        let checkString = stringText.replacingCharacters(in: range, with:string)
        
        selectedCustomerList = nil
        stackViewCusDetail.isUserInteractionEnabled = false
        stackViewCusDetail.alpha = 0.5
//        if checkString != ""
//        {
//            enableDiasbleSearchButton(enabled: true)
//        }
//        else
//        {
//            enableDiasbleSearchButton(enabled: false)
//        }
        
    }
    
    
    
    func selectedSuggestion(object: AnyObject, tag: Int) {
        
        if object is Customerlist
        {
            selectedCustomerList = object as? Customerlist
            stackViewCusDetail.isUserInteractionEnabled = true
            stackViewCusDetail.alpha = 1.0
        }
    }
    
}

