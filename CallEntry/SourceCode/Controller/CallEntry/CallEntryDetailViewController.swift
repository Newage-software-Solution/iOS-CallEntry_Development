//
//  CallEntryDetailViewController.swift
//  CallEntry
//
//  Created by Rajesh on 07/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

class CallEntryDetailViewController: BaseViewController {
    
    // MARK:- View Static Variables -
    
    // MARK:- IBOutlets -
    
    @IBOutlet weak var tableViewCallDetail: UITableView!
    
    // MARK:- Properties -
    
    var callDetail = Calllist()
    
    var model = CallEntryModel()
    
    var customerDetail: Customerlist!
    
    // MARK:- View Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.delegate = self
        configureViewData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- BUSINESS LOGICS -
    
    func configureViewData() {
        
        tableViewCallDetail.register(UINib(nibName: "CustomerInfoTableViewCell", bundle: nil), forCellReuseIdentifier: TableViewCellID.customerInfoTableViewCell.rawValue)

        tableViewCallDetail.register(UINib(nibName: "FollowUpListTableViewCell", bundle: nil), forCellReuseIdentifier: TableViewCellID.followUpListTableViewCell.rawValue)
        
        tableViewCallDetail.estimatedRowHeight = 100
        tableViewCallDetail.rowHeight = UITableViewAutomaticDimension
        tableViewCallDetail.separatorStyle = .none
        customerDetail = DataBaseModel.getCustomerDetailForID(cusId: callDetail.custid)
    }

    func generateShipmentListRequest() -> GetShipmentListRequest {
        
        let request = GetShipmentListRequest()
        request.username = AppCacheManager.sharedInstance().userId
        request.user_token = AppCacheManager.sharedInstance().authToken
        request.code = callDetail.custid

        return request
    }
    
    //MARK:- BUTTON ACTIONS -
     
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editButtonAction(_ sender: Any)
    {
      let customerEditController = self.getViewControllerInstance(storyboardName: StoryBoardID.customer.rawValue, storyboardId: ViewControllerID.newCustomerViewController.rawValue) as! NewCustomerViewController
        customerEditController.isEdit = true
        customerEditController.isEditingTextfield = true
        customerEditController.customerList = AppCacheManager.sharedInstance().customerList.filter( { $0.custid == callDetail.custid } ).first
        let navCtrl = UINavigationController(rootViewController: customerEditController)
        self.navigationController?.present(navCtrl, animated: true, completion: nil)
    }
}

// MARK:- Delegate Methods -

// MARK:- CustomerInfoTableViewCellDelegate Methods -

extension CallEntryDetailViewController: CustomerInfoHeaderViewDelegate {
    func callButtonClicked()
    {
        switch self.callDetail.followups[0].mode.uppercased()
        {
        case "CALL":
            if isValidMobileNumber(mobileNo: self.customerDetail.phoneno)
            {
                self.phoneCalling(phoneNo: self.customerDetail.phoneno)
            }
            else
            {
                self.showAlertMessage(message: AlertMessages.Message.phoneNoInvalid)
            }
        default:
            if isValidEmail(emailAddress: self.customerDetail.emailid)
            {
                self.mail(email: self.customerDetail.emailid)
            }
            else
            {
                self.showAlertMessage(message: AlertMessages.Message.invalidEmailId)
            }
        }
       
      
    }
    
    
    func doneActionClicked() {
        
        let summarypageController = self.getViewControllerInstance(storyboardName: StoryBoardID.summary.rawValue, storyboardId: ViewControllerID.newSummaryViewController.rawValue) as! NewSummaryViewController
        
            summarypageController.customerDetail = self.customerDetail
            summarypageController.followupNo = callDetail.followups.count + 1
            summarypageController.callId     = callDetail.callid
        
        self.navigationController?.pushViewController(summarypageController, animated: true)
    }
    
    
    func shipementHistoryClicked() {
//        self.showLoader()
//        model.getShipmentList(request: generateShipmentListRequest())
        shipmentHistoryReceived()
    }
    
    
    func viewProfileClicked() {
        
            let profileDetailViewController = getViewControllerInstance(storyboardName: StoryBoardID.potentialBusiness.rawValue, storyboardId: ViewControllerID.potentialBusinessDetailViewController.rawValue) as! PotentialBusinessDetailViewController
            SharedPersistance().setCustomerId(custId: self.customerDetail.custid)
            profileDetailViewController.profiles = self.customerDetail.profile
            //profileDetailViewController.cal
        self.navigationController?.pushViewController(profileDetailViewController, animated: true)
        
    }
    
    
    func locationButtonClicked() {
        
        let url = customerDetail.territory == "" ? "http://maps.apple.com/?address=\(customerDetail.city)" : "http://maps.apple.com/?address=\(customerDetail.territory),\(customerDetail.city)"
        UIApplication.shared.openURL(URL(string:url)!)
    }
    
}

// MARK:- CallEntryModelDelegate Methods -

extension CallEntryDetailViewController: CallEntryModelDelegate {
    func shipmentHistoryReceived() {
//        self.removeLoader()
        
        let shipmentHistoryViewController = getViewControllerInstance(storyboardName: StoryBoardID.customer.rawValue, storyboardId: ViewControllerID.shipmentHistoryListViewController.rawValue) as! ShipmentHistoryListViewController
        shipmentHistoryViewController.code = callDetail.custid
        self.navigationController?.pushViewController(shipmentHistoryViewController, animated: true)
    }
    
    func apiHitFailure() {
        self.removeLoader()
    }
}

// MARK: - UITableViewDelegate Methods -

extension CallEntryDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1 //Show Customer Info
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return callDetail.followups.count // show follow up list
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
         let headerView = CustomerInfoHeaderView()
        headerView.delegate = self
        headerView.configureCellContent(callList: callDetail)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellID.followUpListTableViewCell.rawValue, for: indexPath) as! FollowUpListTableViewCell
        
        cell.configureCellContent(followUp: callDetail.followups[indexPath.row])
        cell.accessoryType = UITableViewCellAccessoryType.none
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 221
    }
}
