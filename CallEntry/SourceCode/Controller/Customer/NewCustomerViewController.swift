//
//  NewCustomerViewController.swift
//  CallEntry
//
//  Created by Rajesh on 07/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

class NewCustomerViewController: BaseViewController {
    
    @IBOutlet weak var tbleView: UITableView!
    
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var btnNavigationBack: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    

    var model = CustomerModel()
    var defaultCustomername = ""
    // MARK:- View Static Variables -
    var customerList: Customerlist! = Customerlist()
    var inputFieldTitle: [String] = ["Customer Name", "Address", "Territory", "City", "Country", "Phone No", "Mobile No", "Email ID", "Contact Person", "Potential for Warehousing", "Potential for Clearance"]
    var cellHeightCountryList: CGFloat = OrginAutoListCellHeight.defaultHeight.rawValue
    var textViewpadding: CGFloat = 0
    var textViewHeight: CGFloat = 0
    var countryCode: String = ""
    var isSave: Bool = false
    
    var isOrginFieldEditable : Bool = false
    var isSelectedTextFieldTag : Int = 0
    var countryCodeName: String = ""
    
    // MARK:- IBOutlets -
    
    @IBOutlet weak var lblTitle: UILabel!
    // MARK:- Properties -
    var isEdit: Bool = false
    var isEditingTextfield: Bool = false
    // MARK:- View Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        configureViewData()
        
        configureEditData()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        addObservers()
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        removeObservers()
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(forName: .UIKeyboardWillShow, object: nil, queue: nil) { (notification) in
            self.keyboardWillShow(notification: notification)
        }
        NotificationCenter.default.addObserver(forName: .UIKeyboardWillHide, object: nil, queue: nil) { (notification) in
            self.keyboardWillHide(notification: notification)
        }
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let frame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else {
                return
        }
        
    }
    
    func keyboardWillHide(notification: Notification) {
       
    }
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- BUSINESS LOGICS -
    
    func configureViewData() {
        
        tbleView.register(UINib.init(nibName: "NewCustomerEntryListTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tbleView.register(UINib.init(nibName: "NewCustomerEntryProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "lastcell")
        
        tbleView.register(UINib(nibName: "NewCustomerEntryFooterView", bundle: nil), forCellReuseIdentifier: "FooterCell")
        model.delegate = self
        tbleView.tableFooterView = UIView()
        tbleView.estimatedRowHeight = 62
        tbleView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    func configureEditData() {
       
        btnNavigationBack.isHidden = !isEdit
        btnCancel.isHidden       = isEdit
        if isEdit {
            
            self.lblTitle.text = "Customer Detail"
            self.btnSave.setTitle("Edit", for: .normal)
        }
        else {
            
            self.lblTitle.text = "New Customer Entry"
        }
        self.btnSave.isHidden = self.isSave == true ? true : false
       self.btnSave.setTitle(isEditingTextfield ? "Save" : "Edit", for: .normal)
       self.tbleView.separatorStyle = isEditingTextfield ? .singleLine : .none
    }
    
    func getTheCountryList() -> [String] {
        var countryName: [String] = []
        print(AppCacheManager.sharedInstance().countryList != nil)
        if (((AppCacheManager.sharedInstance().countryList != nil)) && AppCacheManager.sharedInstance().countryList.countryCodeList.count > 0) {
            for iterateCountryName in AppCacheManager.sharedInstance().countryList.countryCodeList {
                countryName.append(iterateCountryName.countryName)
            }
            return countryName
        }
        return countryName
    }
    
    func isValidationSuccess() -> Bool {
        
        return true
    }
    
    @objc func toggleClicked(_ sender: UISwitch) {
        if sender.tag == 9 {
            self.customerList.potentialforwarehousing = sender.isOn == true ? "YES" : "NO"
            print("Warehousing")
        }
        else {
            print("clearance")
             self.customerList.potentialforclearance = sender.isOn == true ? "YES" : "NO"
        }
    }
    
    func generateNewCustomerRequest() -> NewCustomerRequest {
        
       let request = NewCustomerRequest()
        
        request.username = AppCacheManager.sharedInstance().userId
        request.user_token = AppCacheManager.sharedInstance().authToken
        request.name = self.customerList.name
        request.address = self.customerList.address
        request.area = self.customerList.territory
        request.city = self.customerList.city
        request.country = self.countryCode
        request.phone = self.customerList.phoneno
        request.mobile = self.customerList.mobileno
        request.email = self.customerList.emailid
        request.contact = self.customerList.contactperson
        request.warehouse = self.customerList.potentialforwarehousing
        request.clearance = self.customerList.potentialforclearance
        
        return request
    }
    
    func generateUpdateCustomerRequest() -> UpdateCustomerRequest {
        let request = UpdateCustomerRequest()
        request.username = AppCacheManager.sharedInstance().userId
        request.user_token = AppCacheManager.sharedInstance().authToken
        request.code = self.customerList.custid
        request.name = self.customerList.name
        request.address = self.customerList.address
        request.area = self.customerList.territory
        request.city = self.customerList.city
        request.country = self.countryCode
        request.phone = self.customerList.phoneno
        request.mobile = self.customerList.mobileno
        request.email = self.customerList.emailid
        request.contact = self.customerList.contactperson
        request.warehouse = self.customerList.potentialforwarehousing
        request.clearance = self.customerList.potentialforclearance
        return request
    }
    
    func validateCustomerList() -> Bool {
        if self.customerList.name.trimmingCharacters(in: .whitespaces) == "" {
            self.showAlertMessage(message: "please fill the Customer name")
        }
        else if self.customerList.address.trimmingCharacters(in: .whitespaces) == "" {
            self.showAlertMessage(message: "please fill the customer address")
        }
        else if self.customerList.city.trimmingCharacters(in: .whitespaces) == "" {
            self.showAlertMessage(message: "please fill the customer city")
        }
        else if self.customerList.territory.trimmingCharacters(in: .whitespaces) == "" {
            self.showAlertMessage(message: "please fill the customer area")
        }
        else if self.customerList.country.trimmingCharacters(in: .whitespaces) == "" {
            self.showAlertMessage(message: "please fill the customer country")
        }
        else if self.customerList.emailid != "" && !self.isValidEmail(emailAddress: self.customerList.emailid) {
            self.showAlertMessage(message: "invalid Email")
        }
        else if self.customerList.mobileno.count > 12  {
//             if self.customerList.mobileno.count > 12 || !self.isValidMobileNumber(mobileNo: self.customerList.mobileno)  {
            self.showAlertMessage(message: "invalid mobile Number")
           // }
        }
        else if self.customerList.phoneno.count > 12  {
           // if self.customerList.phoneno.count > 12 || !self.isValidMobileNumber(mobileNo: self.customerList.phoneno) {
                self.showAlertMessage(message: "invalid mobile Number")
           /// }
        }
        else
        {
            let country = AppCacheManager.sharedInstance().countryList.countryCodeList.filter { $0.countryName.uppercased() == self.customerList.country.uppercased() }.first?.countryCode
            self.countryCode = country!
            return true
            
        }
        return false
    }
    
    func lastCharacterCheckingForDrop(string: String) -> Bool {
        if string == "" {
            return false
        }
        else {
            return true
        }
    }
    
    //MARK:- BUTTON ACTIONS -
    
    @IBAction func saveButtonAction(_ sender: Any) {
        
        if btnSave.currentTitle == "Save"
        {
            if self.validateCustomerList() {
            self.showLoader()
            model.updateCustomer(request: generateUpdateCustomerRequest())
            }
        }
        self.btnSave.setTitle("Save", for: .normal)
        self.lblTitle.text = "Edit Customer"
        self.isEditingTextfield = true
        self.tbleView.reloadData()
        self.tbleView.separatorStyle = isEditingTextfield ? .singleLine : .none
    }
    
    @IBAction func closeButtonAction(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func nextButtonClicked(_ sender: UIButton) {
       
        if self.validateCustomerList() {
        print("NextButtonClicked API Going to Hit")
        self.showLoader()
        model.newCustomer(request: generateNewCustomerRequest())
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}

extension NewCustomerViewController: CustomerModelDelegate {
    func apiHitFailure(error: Error) {
        self.removeLoader()
        self.showAlertMessage(message: error.localizedDescription)
    }
    
    func apiHitSuccess(key: String) {
        self.tbleView.contentInset = UIEdgeInsets.zero
        if key == "" {
            self.showAlertMessage(message: "Customer key empty")
        }
        let addPotentialBusinessController = self.getViewControllerInstance(storyboardName: StoryBoardID.potentialBusiness.rawValue, storyboardId: ViewControllerID.newPotentialBusinessViewController.rawValue) as! NewPotentialBusinessViewController
        addPotentialBusinessController.customerKey = key
        self.navigationController?.pushViewController(addPotentialBusinessController, animated: true)
        self.removeLoader()
    }
    
    func customerlistUpdatedSuccessfully() {
        self.removeLoader()
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
}

// MARK:- Delegate Methods -
//
//extension ViewControllerName: DelegateName {
//}
extension NewCustomerViewController: UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isEdit {
        return 12
        }
        else
        {
        return 12
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row < 9 && indexPath.row != 4 {
            
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NewCustomerEntryListTableViewCell
            
            cell.txtfldBottom.isUserInteractionEnabled = isEditingTextfield ? true : false
            cell.textViewinput.isUserInteractionEnabled = isEditingTextfield ? true : false
            cell.txtfldBottom.autocorrectionType = .no
            cell.textViewinput.autocorrectionType = .no
            cell.txtfldBottom.spellCheckingType = .no
            cell.textViewinput.spellCheckingType = .no
            cell.imgArrow.isHidden = indexPath.row == 4 ? false : true
            cell.lblTop.text = inputFieldTitle[indexPath.row]
            cell.txtfldBottom.isEnabled = true
            cell.txtfldBottom.tag = indexPath.row
            cell.txtfldBottom.delegate = self
            cell.textViewinput.delegate = self
            cell.textViewinput.tag = indexPath.row
            
            if (indexPath.row == 0){
                if (defaultCustomername != "") {
                     customerList.name = defaultCustomername
                     cell.textViewinput.text = defaultCustomername
                }
            }
            if indexPath.row == 1 || indexPath.row == 0 {
            
                cell.textViewinput.isHidden = false
                cell.textViewinput.delegate = self
                cell.textViewinput.tag = indexPath.row
                cell.txtfldBottom.isHidden = true
            } else {
                
                cell.txtfldBottom.isHidden = false
                cell.textViewinput.isHidden = true
            }
            
            if inputFieldTitle[indexPath.row] == "Phone No" || inputFieldTitle[indexPath.row] == "Mobile No" {
                
                cell.txtfldBottom.keyboardType = .numberPad
            } else {
                
                cell.txtfldBottom.keyboardType = .default
            }
                
        cell.configureEditData(customerList: customerList, indexpath: indexPath)
            if indexPath.row == 1 || indexPath.row == 0 {
                textViewHeight = cell.textViewinput.contentSize.height
            }
           
        return cell
            
        } else if indexPath.row == 4 {
            if let cell = tableView.cellForRow(at: indexPath) as? CountryAutoListTableViewCell {
                
                cell.textFieldcountryList.becomeFirstResponder()
                
                cell.textFieldcountryList.textField.isUserInteractionEnabled = isEditingTextfield ? true : false
                
                cell.textFieldcountryList.textField.tag = indexPath.row
               // cell.textFieldcountryList.textField.delegate = self
                
                cell.selectionStyle = .none
                
                return cell
            }
            else {
         let cell = tableView.dequeueReusableCell(withIdentifier: "CountryAutoListCellIdentifier", for: indexPath) as! CountryAutoListTableViewCell
            cell.textFieldcountryList.textField.isUserInteractionEnabled = isEditingTextfield ? true : false
            cell.textFieldcountryList.textField.tag = indexPath.row
            cell.textFieldcountryList.delegate = self
            cell.textFieldcountryList.textField.returnKeyType = .default
            cell.textFieldcountryList.applyRegex = .none
            cell.textFieldcountryList.textField.text = self.customerList.country
            cell.textFieldcountryList.btnAddNew.isHidden = true
            cell.textFieldcountryList.viewSeparator.isHidden = true
            cell.textFieldcountryList.textField.textColor = UIColor.black
            cell.textFieldcountryList.titleLabel.font = UIFont(name: "Roboto-Light", size: 13)
            cell.textFieldcountryList.textField.font  = UIFont(name: "Roboto-Regular", size: 13)
            cell.textFieldcountryList.titleLabel.text = inputFieldTitle[indexPath.row]
            cell.textFieldcountryList.suggestionList = self.getTheCountryList() as [AnyObject]
            
            return cell
            }
        }
        else if indexPath.row < 11 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewCustomerEntryTableViewCell
            cell.lblTitle.text = inputFieldTitle[indexPath.row]
            cell.switchPotential.isUserInteractionEnabled = isEditingTextfield ? true : false
            cell.switchPotential.tag = indexPath.row
            cell.switchPotential.addTarget(self, action: #selector(toggleClicked(_:)), for: .touchUpInside)
           // if isEdit {
                
                if indexPath.row == 9 && customerList.potentialforwarehousing.uppercased() == "YES"
                {
                cell.switchPotential.setOn(true, animated: true)
                }
                if indexPath.row == 10 && customerList.potentialforclearance.uppercased() == "YES"
                {
                 cell.switchPotential.setOn(true, animated: true)
                }
          //  }
            return cell
        }
        if (isEdit) {
            if indexPath.row == 11 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "lastcell", for: indexPath) as! NewCustomerEntryProfileTableViewCell
                cell.lblTitle.textColor = UIColor.black
                cell.imgArrow.tintColor = UIColor.black
                return cell
            }
        
            if indexPath.row == 12 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "FooterCell", for: indexPath) as! NewCustomerEntryFooterTableViewCell
                cell.buttonNext.addTarget(self, action: #selector(nextButtonClicked(_:)), for: .touchUpInside)
                return cell
            }
        } else {
            if indexPath.row == 11 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "FooterCell", for: indexPath) as! NewCustomerEntryFooterTableViewCell
                cell.buttonNext.addTarget(self, action: #selector(nextButtonClicked(_:)), for: .touchUpInside)
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        if indexPath.row == 1 || indexPath.row == 0
        {
            return isEdit ? textViewpadding + textViewHeight + 28 : textViewpadding + 61
        }
        
        if indexPath.row == 4 {
            return cellHeightCountryList
        }
       return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 4 {
            return cellHeightCountryList
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if(isEdit) {
            if indexPath.row == 11
            {
                let potentialBusinessDetailController = self.getViewControllerInstance(storyboardName: StoryBoardID.potentialBusiness.rawValue, storyboardId: ViewControllerID.potentialBusinessDetailViewController.rawValue) as! PotentialBusinessDetailViewController
                potentialBusinessDetailController.profiles = self.customerList.profile
                self.navigationController?.pushViewController(potentialBusinessDetailController, animated: true)
            }
            else if indexPath.row == 12
            {
                let newPotentialBusinessController = self.getViewControllerInstance(storyboardName: StoryBoardID.potentialBusiness.rawValue, storyboardId: ViewControllerID.newPotentialBusinessViewController.rawValue) as! NewPotentialBusinessViewController
                self.navigationController?.pushViewController(newPotentialBusinessController, animated: true)
               
            }
        } else {
            if (indexPath.row == 11) {
                let potentialBusinessDetailController = self.getViewControllerInstance(storyboardName: StoryBoardID.potentialBusiness.rawValue, storyboardId: ViewControllerID.potentialBusinessDetailViewController.rawValue) as! PotentialBusinessDetailViewController
                potentialBusinessDetailController.profiles = self.customerList.profile
                self.navigationController?.pushViewController(potentialBusinessDetailController, animated: true)
            }
        }
    }
}
    


extension NewCustomerViewController: UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
        textField.becomeFirstResponder()
        if textField.tag > 3
        {
            self.tbleView.contentInset = UIEdgeInsetsMake(0, 0, 300, 0)
            self.tbleView.scrollToRow(at: IndexPath(row: textField.tag, section: 0), at: .bottom, animated: true)
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        print("Country",self.customerList.country)
        if string.count > 1 {
            self.tbleView.reloadData()
        }
        if (isBackSpace == -92) {
            print("Backspace was pressed")
        switch textField.tag {
        case 2:
            self.customerList.territory.removeLast()
        case 3:
            self.customerList.city.removeLast()
//        case 4:
//            self.customerList.country.removeLast()
        case 5:
            self.customerList.phoneno.removeLast()
        case 6:
            self.customerList.mobileno.removeLast()
        case 7:
            self.customerList.emailid.removeLast()
        case 8:
            self.customerList.contactperson.removeLast()
        default:
            print("None")
        }
        }
        else {
        switch textField.tag {
        case 2:
            self.customerList.territory = textField.text! + string
        case 3:
            self.customerList.city = textField.text! + string
//        case 4:
//            self.customerList.country = textField.text! + string
        case 5:
            if (textField.text! + string).count > 12 {
                return false
            }
            self.customerList.phoneno = textField.text! + string
        case 6:
            if (textField.text! + string).count > 12 {
                return false
            }
            self.customerList.mobileno = textField.text! + string
        case 7:
            self.customerList.emailid = textField.text! + string
        case 8:
            self.customerList.contactperson = textField.text! + string
        default:
            print("None")
        }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        switch textField.tag {
        case 2:
            self.customerList.territory = textField.text!
        case 3:
            self.customerList.city = textField.text!
//        case 4:
//            self.customerList.country = textField.text!
        case 5:
            self.customerList.phoneno = textField.text!
        case 6:
            self.customerList.mobileno = textField.text!
        case 7:
            self.customerList.emailid = textField.text!
        case 8:
            self.customerList.contactperson = textField.text!
        default:
            print("None")
        }
        self.tbleView.contentInset = UIEdgeInsets.zero
        textField.endEditing(true)
        return true
    }
}

extension NewCustomerViewController: UITextViewDelegate
{
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        
        textView.becomeFirstResponder()
    }
    
    
    func textViewDidChange(_ textView: UITextView)
    {
        print(textView.contentSize.height)
        if textView.contentSize.height > textView.frame.size.height
        {
             tbleView.beginUpdates()
            textViewpadding += 10
             tbleView.endUpdates()
        }
        else if textView.contentSize.height + 10 < textView.frame.size.height
        {
            tbleView.beginUpdates()
            textViewpadding -= 10
            tbleView.endUpdates()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        let char = text.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if text.count > 1 {
            self.tbleView.reloadData()
        }
        
        if (isBackSpace == -92) {
            switch textView.tag {
            case 0:
                if self.lastCharacterCheckingForDrop(string: self.customerList.name) {
                self.customerList.name.removeLast()
                }
            case 1:
                if self.lastCharacterCheckingForDrop(string: self.customerList.address) {
                self.customerList.address.removeLast()
                }
            default:
                print("nil")
            }
        }
        else {
        switch textView.tag {
        case 0:
            self.customerList.name = textView.text + text
        case 1:
            self.customerList.address = textView.text + text
        default:
            print("nil")
        }
        }
        if text == "\n"
        {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
    
}

extension NewCustomerViewController: HMSuggestionTextFieldDelegate {
  
    func suggestionTextFieldDidBeginEditing(_ textField: UITextField) {
        
        isOrginFieldEditable = true
        isSelectedTextFieldTag = textField.tag
        
    }
    
    
    func suggestionTextFieldDidEndEditing(_ textField: UITextField) {
        
        isOrginFieldEditable = false
        isSelectedTextFieldTag = textField.tag
    }
    func suggestionTextFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        textField.resignFirstResponder()
        
        return true
    }
    
    func updateHeightConstraintsHMSuggestion(height: CGFloat, tag : Int) {
        if isSelectedTextFieldTag == 4 {
        if cellHeightCountryList != OrginAutoListCellHeight.listSelectHeight.rawValue && isOrginFieldEditable {
            
            cellHeightCountryList = OrginAutoListCellHeight.listSelectHeight.rawValue
            tbleView.reloadRows(at: [IndexPath(row: isSelectedTextFieldTag, section: 0)], with: .none)
        }
        }
    }
    
    func selectedSuggestion(object: AnyObject, tag: Int) {
        
        if object is String {
            self.countryCodeName = object as! String
        }
        
        isOrginFieldEditable = false
        
        if isSelectedTextFieldTag == 4 {
            self.customerList.country = self.countryCodeName
            if cellHeightCountryList == OrginAutoListCellHeight.listSelectHeight.rawValue {
                
                cellHeightCountryList = OrginAutoListCellHeight.defaultHeight.rawValue
            }
        }
        self.tbleView.reloadData()
    }
    
}
    
    


