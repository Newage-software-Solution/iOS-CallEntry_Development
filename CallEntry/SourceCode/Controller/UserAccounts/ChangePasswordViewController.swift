//
//  ChangePasswordViewController.swift
//  CallEntry
//
//  Created by Rajesh on 07/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

class ChangePasswordViewController: BaseViewController {
    
    // MARK:- View Static Variables -
    
    // MARK:- IBOutlets -
    @IBOutlet weak var textFieldCurrentPassword: UITextField!
    
    @IBOutlet weak var btnsave: UIButton!
    @IBOutlet weak var textFieldNewPassword: UITextField!
    
    @IBOutlet weak var textFieldConfirmPassword: UITextField!
    
    // MARK:- Properties -
    
    var model = UserAccountModel()
    
    // MARK:- View Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.delegate = self
        self.btnsave.isEnabled = false
        self.btnsave.alpha = 0.5
        configureViewData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- BUSINESS LOGICS -
    
    func configureViewData() {
        self.textFieldCurrentPassword.delegate = self
        self.textFieldNewPassword.delegate = self
        self.textFieldConfirmPassword.delegate = self
    }
    
    func isValidationSuccess() -> Bool {
        
        return true
    }
    
    func generateRequest() -> ChangePasswordRequest {
        
        let request = ChangePasswordRequest()
        request.new_password = textFieldNewPassword.text!
        request.username = AppCacheManager.sharedInstance().userId
        request.user_token = AppCacheManager.sharedInstance().authToken
        return request
    }
    
    func showAlertMessageWithOkAction(message : String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let retry = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            self.textFieldConfirmPassword.resignFirstResponder()
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(retry)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK:- BUTTON ACTIONS -
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonAction(_ sender: UIButton)
    {
        if ((self.textFieldNewPassword.text?.count)! > 3 && (self.textFieldConfirmPassword.text?.count)! > 3 && (self.textFieldCurrentPassword.text?.count)! > 3) {
            self.changePasswordRequest()
        }
        else {
            if (self.textFieldNewPassword.text?.count)! < 3 {
                self.showAlertMessage(message: "Invalid new password length")
            } else if (self.textFieldConfirmPassword.text?.count)! < 3  {
                self.showAlertMessage(message: "Invalid confirm password length")
            } else {
                self.showAlertMessage(message: "Invalid current password length")
            }
        }
    }
    
    func changePasswordRequest(){
        if (textFieldNewPassword.text == textFieldConfirmPassword.text){
            model.changeUserPasswordRequest(request: generateRequest())
        } else {
            self.showAlertMessage(message: AlertMessages.Message.unmatchPassword)
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

// MARK:- Delegate Methods -
//
//extension ViewControllerName: DelegateName {
//}
extension ChangePasswordViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        switch textField
        {
        case textFieldCurrentPassword:
            textFieldNewPassword.becomeFirstResponder()
        case textFieldNewPassword:
            textFieldConfirmPassword.becomeFirstResponder()
        case textFieldConfirmPassword:
            if ((self.textFieldNewPassword.text != "") && (self.textFieldConfirmPassword.text != "") && (self.textFieldCurrentPassword.text != "")) {
                self.btnsave.isEnabled = true
                self.btnsave.alpha = 1.0
            }
            textField.endEditing(true)
        default:
            break
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if ((self.textFieldNewPassword.text != "") && (self.textFieldConfirmPassword.text != "") && (self.textFieldCurrentPassword.text != "")) {
            self.btnsave.isEnabled = true
            self.btnsave.alpha = 1.0
        } 
    }
}

extension ChangePasswordViewController: UserAccountModelDelegate {
    func employeeListReceived(response: [EmployeeDetail]) {
        //optional method
    }
    
    func masterDataReceived() {
        //optional method
    }
    
    func portDataReceived() {
        //optional method
    }
    
    func customerListReceived() {
        //optional method
    }
    
    func loginSuccess(response: LoginResponse) {
        //optional method
    }
    
    func apiHitFailure() {
        //optional method
    }
    
    func changePassword(message: String) {
        self.showAlertMessageWithOkAction(message: message)
    }
}
