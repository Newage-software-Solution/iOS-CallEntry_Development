//
//  ForgotPasswordViewController.swift
//  CallEntry
//
//  Created by Rajesh on 07/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

protocol ForgotPasswordSuccessDelegate {
    func forgotPasswordSent(message: String)
}

class ForgotPasswordViewController: BaseViewController {
    
    // MARK:- View Static Variables -
    
    // MARK:- IBOutlets -
    
    @IBOutlet weak var txtfieldEmail: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var btnForgotPwd: UIButton!
    
   // var delegate: ForgotPasswordSuccessDelegate!
    // MARK:- Properties -
    
    // MARK:- View Life Cycle -
    
    var model = UserAccountModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnForgotPwd.layer.cornerRadius = 12.0
        configureViewData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- BUSINESS LOGICS -
    
    func configureViewData() {
        txtfieldEmail.placeHolderColor = UIColor.black
        model.delegate = self
    }

    func isValidationSuccess() -> Bool {
        
        return true
    }
    
    func generateRequest() -> ForgotPasswordRequest {
        
        let request = ForgotPasswordRequest()
        
        request.username = txtfieldEmail.text ?? ""
        
        return request
    }
    
    //MARK:- BUTTON ACTIONS -
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitButtonAction(_ sender: UIButton) {
        
        if (txtfieldEmail.text ?? "") != "" {
            self.showLoader()
            model.forgotPassword(request: generateRequest())
        }
        else {
            showAlertMessage(message: "Username is empty")
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
extension ForgotPasswordViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 150, 0)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        scrollView.contentInset = UIEdgeInsets.zero
        textField.endEditing(true)
        return true
    }
}

extension ForgotPasswordViewController: UserAccountModelDelegate {
    
    func employeeListReceived(response: [EmployeeDetail]) {
        //optional method
    }
    func masterDataReceived() {
        
    }
    
    func portDataReceived() {
        
    }
    
    func customerListReceived() {
        
    }
    
    func loginSuccess(response: LoginResponse) {
        
    }
    
    func apiHitFailure() {
        self.removeLoader()
    }
    
    func changePassword(message: String) {
        self.removeLoader()
//        self.navigationController?.popViewController(animated: true)
    //    self.delegate.forgotPasswordSent(message: message)
       showAlertMessage(message: message)
    }
    
    
    
    
}

