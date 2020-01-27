//
//  CustomerListViewController.swift
//  CallEntry
//
//  Created by Rajesh on 07/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit
import ContactsUI

class CustomerListViewController: BaseViewController {
    
    // MARK:- View Static Variables -
    
    // MARK:- IBOutlets -
    
    @IBOutlet weak var tableViewCustomerList: UITableView!
    @IBOutlet weak var viewSearchBar: UIView!
    @IBOutlet weak var textFieldSearch: UITextField!{
        didSet{
            self.textFieldSearch.delegate = self
        }
    }
    
    
    // MARK:- Properties -
    
    var customerList: [Customerlist] = []
    var tempCustomerList: [Customerlist] = []{
        didSet{
            tableViewCustomerList.reloadData()
        }
    }
    
    var model = UserAccountModel()
    
    // MARK:- View Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        customerList = AppCacheManager.sharedInstance().customerList
        configureViewData()
        tableViewCustomerList.estimatedRowHeight = 130
        tableViewCustomerList.rowHeight = UITableViewAutomaticDimension
        model.delegate = self
        textFieldSearch.delegate = self
        tempCustomerList = AppCacheManager.sharedInstance().customerList
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
    
    func configureViewData() {
        
        customerList = AppCacheManager.sharedInstance().customerList.filter { $0.salesman == "" }.sorted(by: { $0.name < $1.name })
        
        tempCustomerList = customerList
        
        tableViewCustomerList.register(UINib.init(nibName: "CustomerListTableViewCell", bundle: nil), forCellReuseIdentifier: TableViewCellID.customerListTableViewCell.rawValue)
        
        viewSearchBar.isHidden = true
        
        
        
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
    
    func generateCustomerListRequest() -> CustomerListRequest {
        
        let request = CustomerListRequest()
        request.userid = AppCacheManager.sharedInstance().userId
        request.usertoken = AppCacheManager.sharedInstance().authToken
        
        if CustomerListDB.fetchCustomerList().count > 0 {
            
            request.updateddata = ""
            
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
            request.updateddata = ""
            request.lastmodifieddate = Date().dateToString(outputFormat: DateFormatConstant.regularFormat)
            
        }
        print(request.lastmodifieddate)
        
        return request
    }
    
    //MARK:- BUTTON ACTIONS -
    
    @IBAction func addButtonAction(_ sender: Any) {
        let newCustomerViewCtrl = getViewControllerInstance(storyboardName: StoryBoardID.customer.rawValue, storyboardId: ViewControllerID.newCustomerViewController.rawValue) as! NewCustomerViewController
        newCustomerViewCtrl.isEditingTextfield = true
        newCustomerViewCtrl.isSave = true
        let navCtrl = UINavigationController(rootViewController: newCustomerViewCtrl)
        self.present(navCtrl, animated: true, completion: nil)
        
    }
    
    @IBAction func cancelSearchAction(_ sender: UIButton) {
        
        self.viewSearchBar.isHidden = true
        textFieldSearch.text = ""
        customerList = tempCustomerList
        tableViewCustomerList.reloadData()
        textFieldSearch.resignFirstResponder()
        
    }
    
    @IBAction func searchButtonAction(_ sender: UIButton) {
        
        textFieldSearch.becomeFirstResponder()
        self.viewSearchBar.isHidden = false
        
    }
    
    @IBAction func customerUpdateButtonAction(_ sender: UIButton) {
        
         self.showLoader()
        DispatchQueue.main.async {
           
             self.model.getCustomerList(request: self.generateCustomerListRequest())
        }
    }
}


extension CustomerListViewController: UserAccountModelDelegate {
    func employeeListReceived(response: [EmployeeDetail]) {
        //optional method
    }
    func masterDataReceived() {
        
    }
    
    func portDataReceived() {
        
    }
    
    func customerListReceived() {
        UserDefaultModel.updateLastModifiedDate()
        removeLoader()
        customerList = AppCacheManager.sharedInstance().customerList.filter { $0.salesman == "Y" }.sorted(by: { $0.name < $1.name })
        tempCustomerList = customerList
        self.tableViewCustomerList.reloadData()
    }
    
    func loginSuccess(response: LoginResponse) {
        
    }
    
    func apiHitFailure() {
        
    }
    
    func changePassword(message: String) {
        
    }
    
    
}

/// MARK:- TextField Delegate

extension CustomerListViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        tempCustomerList = textField.text!.isEmpty ? AppCacheManager.sharedInstance().customerList : tempCustomerList.filter { $0.name.range(of: textField.text!, options: .caseInsensitive) != nil }
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        print("Clear Button")
        
        DispatchQueue.main.async {
            self.customerList = self.tempCustomerList
            self.tableViewCustomerList.reloadData()
        }
        
        return true
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var searchText: String = ""
       
        searchText = (textField.text ?? "") + string
        
        let isBackSpace = strcmp(string.cString(using: String.Encoding.utf8), "\\b")
        
        if isBackSpace == -92 {
            searchText.removeLast()
        }
       
        customerList = searchText.isEmpty ? tempCustomerList : tempCustomerList.filter { $0.name.range(of: searchText, options: .caseInsensitive) != nil }
        
        tableViewCustomerList.reloadData()
       
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}


//MARK:- UITableViewDelegate Methods -

extension CustomerListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempCustomerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellID.customerListTableViewCell.rawValue, for: indexPath) as! CustomerListTableViewCell
        cell.callDelegate = self
        cell.ProfileButtonActionDelegate = self
        cell.customerEditButtonDelegate = self
        cell.btnCustomerName.tag = indexPath.row
        cell.btnProfile.tag = indexPath.row
        cell.btnCall.tag = indexPath.row
        cell.configureCellContent(customerList: tempCustomerList[indexPath.row])
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Did Select")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
}
// Call Button Action

extension CustomerListViewController: CallDelegate {
    
    func callButtonAction(_ sender: Any)
    {
        print("calling")
        if let btnCall = sender as? UIButton {
            let phoneNo = (customerList[btnCall.tag].phoneno).replacingOccurrences(of: " ", with: "")
            calling(phoneNo: phoneNo)
        }
    }
}

extension CustomerListViewController: CNContactPickerDelegate
{
    func calling(phoneNo: String)
    {
        if isValidMobileNumber(mobileNo: phoneNo)
        {
           self.phoneCalling(phoneNo: phoneNo)
        }
        else
        {
            self.showBottomAlert(message: AlertMessages.Message.phoneNoInvalid)
           //self.showAlertMessage(message: AlertMessages.Message.phoneNoInvalid)
        }
    }
}

extension CustomerListViewController: ProfileButtonDelegate {
    
    func profileButtonAction(_ sender: Any) {
        
        if let btnProfile = sender as? UIButton {
            
            let potentialBusinessController = self.getViewControllerInstance(storyboardName: StoryBoardID.potentialBusiness.rawValue, storyboardId: ViewControllerID.potentialBusinessDetailViewController.rawValue) as! PotentialBusinessDetailViewController
            potentialBusinessController.profiles = AppCacheManager.sharedInstance().customerList[btnProfile.tag].profile
           // SharedPersistance().setCustomerId(custId: AppCacheManager.sharedInstance().customerList[btnProfile.tag].custid)
            potentialBusinessController.custid = AppCacheManager.sharedInstance().customerList[btnProfile.tag].custid
            potentialBusinessController.isFrom = "CustomerList"
            self.navigationController?.pushViewController(potentialBusinessController, animated: true)
        }
    }
}


extension CustomerListViewController: CustomerButtonDelegate {
    
    func customerEditButtonAction(_ sender: Any) {
        let customerEditcontroller = self.getViewControllerInstance(storyboardName: StoryBoardID.customer.rawValue, storyboardId: ViewControllerID.newCustomerViewController.rawValue) as! NewCustomerViewController
        customerEditcontroller.customerList = self.customerList[(sender as! UIButton).tag]
        customerEditcontroller.isEdit = true
        self.navigationController?.pushViewController(customerEditcontroller, animated: true)
    }
}


//MARK:- getting indexpath from components in cell
extension CustomerListViewController {
    
    func getIndexpath(_ Sender: Any) -> IndexPath
    {
        if let button = Sender as? UIButton
        {
            if let superview = button.superview
            {
                if let cell = superview.superview as? CustomerListTableViewCell
                {
                    let indexPath = tableViewCustomerList.indexPath(for: cell)! as IndexPath
                    return indexPath
                }
            }
        }
        return IndexPath()
    }
}


