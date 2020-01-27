//
//  JoinCallViewController.swift
//  CallEntry
//
//  Created by Newage Software and Solutions on 17/12/19.
//  Copyright © 2019 Rajesh. All rights reserved.
//

import UIKit
import Alamofire
class JoinCallViewController: BaseViewController {
    
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtName: HMSuggestionTextField!
    @IBOutlet weak var txtView: UITextView!
    var selectedEmployeeDetail: EmployeeDetail!

    var allSavedData = [JoinCallDataSaving]()
    var savedArr = [String]()
    var defaults = UserDefaults.standard
    var dictPassValue = [String: String]()
    
    @IBOutlet weak var heightConstraintForTextFieldCustomer: NSLayoutConstraint!

    var currentTextField: UITextField!

    
    override func viewDidLoad() {
        //defaults.set("", forKey: "SavedStringArray")
        super.viewDidLoad()
        createLayoutView()
    }
    
    //MARK: - Ceate Layout Views
    func createLayoutView() {
        self.btnUpdate.cornerRadius = 12.0
        self.txtView.layer.borderWidth = 1.0
        self.txtView.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        self.txtView.cornerRadius = 10.0
        txtName.delegate = self
        txtName.titleLabel.text = "Name";
        txtName.btnAddNew.isHidden = true
        txtName.textField.returnKeyType = .default
        txtName.applyRegex = .none
        let userAccountModel = UserAccountModel()
        
        userAccountModel.delegate = self
        userAccountModel.getEmployeeDetailList(request: self.generateCustomerListRequest())
        showLoader()
        
        if defaults.value(forKey: "SavedStringArray") != nil && !(defaults.value(forKey: "SavedStringArray") as! String).elementsEqual("") {
            let data = Data((defaults.value(forKey: "SavedStringArray") as! String).utf8)
            let json_Data = try! JSONDecoder().decode([JoinCallDataSaving].self, from: data)
            allSavedData = json_Data
        }
        
        
        tableView.reloadData()
        
    }

    func generateCustomerListRequest() -> EmployeeDetailListRequest {
    
        let request = EmployeeDetailListRequest()
        request.userid = AppCacheManager.sharedInstance().userId
        request.usertoken = AppCacheManager.sharedInstance().authToken
        
        return request
    }
    // MARK: - Button Action
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func updateButtonAction(_ sender: Any) {
       
        if isValidationSuccess() {
        self.view.endEditing(true)
        let joinCall = JoinCallDataSaving.init(name: selectedEmployeeDetail.name, desc: txtView.text!, code: selectedEmployeeDetail.code)
        self.addData(joinCollObj: joinCall)
        currentTextField.text = ""
        txtView.text = ""

        }
    }
    // MARK: - Validation
    func isValidationSuccess() -> Bool {
        
        if currentTextField == nil {
            showBottomAlert(message: "Please select the customer")
            return false
            
        } else if txtView == nil {
            showBottomAlert(message: "Please fill the description")
            return false
        }
        
        return true
    }
    func addData(joinCollObj:JoinCallDataSaving) {
        
        allSavedData.append(joinCollObj)
        let jsonData = try! JSONEncoder().encode(allSavedData)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        defaults.set(jsonString, forKey: "SavedStringArray")
        self.tableView.reloadData()

    }
}
// MARK: - UITableView Delegates
extension JoinCallViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allSavedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JoinCallTableCell") as! JoinCallTableCell
        let currentObj = allSavedData[indexPath.row] as JoinCallDataSaving
        cell.lblName.text = "Name: \(currentObj.nameSave!)"// + "Raj"
        cell.lblDesc.text = "Description: \(currentObj.descriptSave!)"// + "Developer"
        return cell
    }
    
    
}

extension JoinCallViewController:UserAccountModelDelegate{
    func masterDataReceived() {
        
    }
    
    func portDataReceived() {
        
    }
    
    func customerListReceived() {
        
    }
    
    func employeeListReceived(response: [EmployeeDetail]) {
        removeLoader()
        txtName.suggestionList = response as [AnyObject]
    }
    
    func loginSuccess(response: LoginResponse) {
        
    }
    
    func apiHitFailure() {
        
    }
    
    func changePassword(message: String) {
        
    }
}

// MARK: - HMSuggestionTextFieldDelegate Methods -
extension JoinCallViewController: HMSuggestionTextFieldDelegate {
    func updateHeightConstraintsHMSuggestion(height: CGFloat, tag: Int) {
        let defaultHeight: CGFloat = 50.0 //Textfield Height + Title Label + View Separator Height
        
        if currentTextField == txtName.textField
        {
            heightConstraintForTextFieldCustomer.constant = defaultHeight + height
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
        
        selectedEmployeeDetail = nil
//        stackViewCusDetail.isUserInteractionEnabled = false
//        stackViewCusDetail.alpha = 0.5
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
        
        if object is EmployeeDetail
        {
            selectedEmployeeDetail = object as? EmployeeDetail
//            stackViewCusDetail.isUserInteractionEnabled = true
//            stackViewCusDetail.alpha = 1.0
        }
    }
    
}
