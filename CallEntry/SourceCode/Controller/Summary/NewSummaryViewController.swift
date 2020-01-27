//
//  NewSummaryViewController.swift
//  CallEntry
//
//  Created by Rajesh on 07/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

@objc protocol NewSummaryViewControllerDelegates {
    
    @objc optional func nameOfUser(name : String)
}


enum NewSummary : String {
    
    case radioButton = "RadioButton"
    case description = "Description"
    case callMode    = "CallMode"
}


class NewSummaryViewController: BaseViewController {
    
    // MARK:- View Static Variables -
    
    // MARK:- View Dynamic Variables -
    
    var action: String = "completed"
    var descriptionComment : String = ""
    var followUpDate : String = ""
    var followUpActionName : String = ""
    var callMode : String = ""
    
    var charactersCount: Int = 0
    
    var customerDetail: Customerlist!
    var followupNo: Int = 0
    var callId : String = ""
    var newSummaryDelegate : NewSummaryViewControllerDelegates?
    
    var model = SummaryModel()
   
    
    // MARK:- IBOutlets -
    
//    @IBOutlet weak var txtFieldFollowUpDate: HMCompoField!
    
    @IBOutlet weak var viewFooter: UIView!
    @IBOutlet weak var tbleView: UITableView!
    
    @IBOutlet weak var lblCustomerName: UILabel!
    
    @IBOutlet weak var lblFollowUpNo: UILabel!
    @IBOutlet weak var constrainsTblViewBottom: NSLayoutConstraint!
    
    // MARK:- Properties -
    var tblData = [NewSummary.radioButton.rawValue, NewSummary.description.rawValue]
 

    //MARK:- View Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewData()
        
        model.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //self.registerForKeyboardNotifications()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
         //NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- BUSINESS LOGICS -
    
    func configureViewData()
    {
        tbleView.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "commentCell")
      self.lblCustomerName.text = customerDetail.name
      self.lblFollowUpNo.text = "Followup" // No". \(followupNo)"
        
    }
    
    func configureEditData() {
        
    }
    
    func isValidationSuccess() -> Bool {
        
        return true
    }
    
    func generateRequest() -> UpdateSummaryRequest {
        
        let request = UpdateSummaryRequest()
        
        request.username        = AppCacheManager.sharedInstance().userId
        request.user_token      = AppCacheManager.sharedInstance().authToken
        request.call_id         = callId
        request.completed       = action == "completed" ? "Yes" : "No"
        request.desc            = descriptionComment
        if request.completed != "Yes" {
            
            request.follow_date     = AppCacheManager.sharedInstance().followUpData
            request.call_mode       = callMode
            request.follow_action   = CallEntryModel().getFollowupActionId(followupAct: AppCacheManager.sharedInstance().masterData.followupaction, name: followUpActionName)
        }
        
        request.run_date        = getTheCurrentDateWithFormat(dateFormat: "dd-MMM-yyyy")
        
        return request
    }
    
    // Reload tableView with animation
    
    func reloadSection(start: Int,range: Int) {
        
        let range = NSMakeRange(start, range)
        let sections = NSIndexSet.init(indexesIn: range)
        self.tbleView.reloadSections((sections as NSIndexSet) as IndexSet, with: .automatic)
    }
    
    
    //Sales man Record Request
    func UpdateSalesmanRecordRequest(key: String) -> SalesmanRecord {
        
        let request = SalesmanRecord()
        request.score = AppCacheManager.sharedInstance().todayScore
        request.userid = AppCacheManager.sharedInstance().userId
        request.key = key
        
        return request
    }
  
    
    func updateSalesmanRecord() {
        
       let todayDateString = getTheCurrentDate()
        
        let getWishDataAry = SharedPersistance().getBreakPreviousRecord().split(separator: "+")
        if getWishDataAry.count > 2 {
            if String(getWishDataAry[0]) == todayDateString {
         
                let data = (Int(getWishDataAry[1]) ?? 0) + 1
                SharedPersistance().setBreakPreviousRecord(data: "\(todayDateString)+\(data)+\(data)")
            } else {
                
                let data = (Int(getWishDataAry[2]) ?? 0) + 1
                SharedPersistance().setBreakPreviousRecord(data: "\(getWishDataAry[0])+\(getWishDataAry[1])+\(data)")
                
                if Int(getWishDataAry[1]) == Int(data + 3) {
                    
                    SharedPersistance().setThreeMoreCallBreakRecord(data: "\(todayDateString)+true)")
                }
            }
        } else {
            
            SharedPersistance().setBreakPreviousRecord(data: "\(todayDateString)+\("1")+\("0")")
        }
        
        /*
        AppCacheManager.sharedInstance().todayScore += 1
        UserDefaultModel.updateSalesmanRecord(request: UpdateSalesmanRecordRequest(key: UIConstants.UserDefaultKey.today + AppCacheManager.sharedInstance().userId))
        
        if AppCacheManager.sharedInstance().todayScore > UserDefaultModel.getSalesmanRecord(request: AppCacheManager.sharedInstance().userId)! {
            
            UserDefaultModel.updateSalesmanRecord(request: UpdateSalesmanRecordRequest(key: UIConstants.UserDefaultKey.highScore))
        }
         */
    }
    
    
    //MARK:- BUTTON ACTIONS -
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func completedButtonAction(_ sender: Any) {
        
        action = "completed"
        tblData = [NewSummary.radioButton.rawValue, NewSummary.description.rawValue]
        self.tbleView.reloadData()
    }
    
    @IBAction func followupButtonAction(_ sender: Any) {
        
        action = "followup"
        tblData = [NewSummary.radioButton.rawValue, NewSummary.callMode.rawValue ,NewSummary.description.rawValue]
        self.tbleView.reloadData()
    }
    
    
    @IBAction func submitButtonAction(_ sender: Any) {
        
        if (descriptionComment == "") {
            showAlertMessage(message: "Please enter followUp comments")
        } else {
                if AppCacheManager.sharedInstance().isManager == "N" {
                    self.updateSalesmanRecord()
                }
                showLoader()
                self.view.endEditing(true)
                model.updateSummary(request: generateRequest())
            }
        }
    }

// MARK:- Delegate Methods -
//
//extension ViewControllerName: DelegateName {
//}
extension NewSummaryViewController: UITableViewDataSource,UITableViewDelegate {
    
    // Mark TableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return tblData.count //action == "completed" ? 2 : 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tblData[indexPath.section] {
        case NewSummary.radioButton.rawValue:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SummaryTypeTableViewCell
            if action == "completed" {
                
                cell.configureCellData(imageCompleted: "radioBlueSelect", imageFollowUp: "radioBlueUnselect", completedTextColor: UIColor(hex: "000000").withAlphaComponent(0.87), followUpTextColor: UIColor(hex: "404040").withAlphaComponent(0.8))
            } else {
                
                cell.configureCellData(imageCompleted: "radioBlueUnselect", imageFollowUp: "radioBlueSelect", completedTextColor: UIColor(hex: "404040").withAlphaComponent(0.8), followUpTextColor: UIColor(hex: "000000").withAlphaComponent(0.87))
            }
            
            return cell
            
        case NewSummary.description.rawValue:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentTableViewCell
            
            cell.commentDelegate = self
            
            return cell
            
        default:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "followupcell", for: indexPath) as! FollowUpTableViewCell
            
            cell.followUp = CallEntryModel().getFollowupAction(followupAct: AppCacheManager.sharedInstance().masterData.followupaction)
            
            cell.textfieldFollowUpDate.pickerDelegate = self
            cell.followUpDelegate = self
            
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {

        switch tblData[section] {
        case NewSummary.radioButton.rawValue:
            return 11
        case NewSummary.description.rawValue:
            return 10
        default:
            return 0
        }
        //return section == 0 ? 11 : section == 1 && action == "completed" ? 80 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

        let footer = UIView()
        footer.backgroundColor = UIColor(hex: "f4f4f4")
        return footer
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch tblData[indexPath.section] {
        case NewSummary.radioButton.rawValue:
            return 113
        case NewSummary.description.rawValue:
            return 207
        default:
            return 346
        }
        //return indexPath.section == 1 ? 207 : indexPath.section == 0 ? 113 : 346
    }
}

extension NewSummaryViewController: HMPickerDelegate {
    
    func pickerSelected(index : Int, selectedTag : Int,withData : AnyObject) {
        
    }
}


extension NewSummaryViewController : CommentTableViewCellDelegates {
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        self.keyboardWillBeShown()
    }
    
    func txtViewDescription(desc : String) {
        
        descriptionComment = desc
        self.keyboardWillBeHidden()
    }
}


extension NewSummaryViewController : FollowUpTableViewCellDelegates {
    
    func textfieldFollowUpDate(followDate : String) {
        
        followUpDate = followDate
    }
    
    func callModeType(callMode : String) {
        
        self.callMode = callMode
    }
    
    
    func followAction(followAction : String) {
        
        self.followUpActionName = followAction
    }
}


extension NewSummaryViewController : SummaryModelDelegate {
    
    func apiHitSuccess() {
        
        self.removeLoader()
        
        AppCacheManager.sharedInstance().followUpData = ""
        showBottomAlertWithGreenBG(message: "FollowUp had updated successfully.")
        AppCacheManager.sharedInstance().reloadDashBoard = true
        //AppCacheManager.sharedInstance().followUpDataSuccessCustomerName =
        
        SharedPersistance().setCustomerQuerySuccess(name: "\(customerDetail.name)+true")
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func apiHitFailure() {
        
        self.removeLoader()
        AppCacheManager.sharedInstance().followUpData = ""
        showBottomAlert(message: AlertMessages.Message.serverError)
    }
}


extension NewSummaryViewController {
    
    func registerForKeyboardNotifications() {
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.keyboardWillBeShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillBeShown() {
        
        //let keyboardSize = (sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        
            self.constrainsTblViewBottom.constant = 200
            self.view.layoutIfNeeded()
            
            tbleView.scrollToRow(at: IndexPath(row: 0, section: (tblData.count - 1)), at: .bottom, animated: true)
    }
    
    @objc func keyboardWillBeHidden() {
    
        self.constrainsTblViewBottom.constant = -5
        self.view.layoutIfNeeded()
    }
}

