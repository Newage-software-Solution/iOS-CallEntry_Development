//
//  CallHistoryListViewController.swift
//  CallEntry
//
//  Created by Rajesh on 16/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

class CallHistoryListViewController: BaseViewController {

    // MARK:- View Static Variables -

    // MARK:- IBOutlets -

    @IBOutlet weak var tableViewCallHistory: UITableView!
    
    // MARK:- Properties -
    
    var callHistory: [Callhistory]  = []
    
    var model = CallEntryModel()
    
    var custId: String = ""
    
    // MARK:- View Life Cycle -
   
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- BUSINESS LOGICS -
    
    func configureViewData() {
        
        showLoader()
        
        model.getCallHistoryList(request: generateCallhistoryRequest())
        
        model.delegate = self
        
        tableViewCallHistory.register(UINib.init(nibName: "CallHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: TableViewCellID.callHistoryTableViewCell.rawValue)
        
        self.tableViewCallHistory.tableFooterView = UIView()
    }
    
    private func generateCallhistoryRequest() -> CallhistoryRequest {
        
        let request = CallhistoryRequest()
        
        request.username = AppCacheManager.sharedInstance().userId
        request.user_token = AppCacheManager.sharedInstance().authToken
        request.customer_code = custId
        
        return request
        
    }
    
    //MARK:- BUTTON ACTIONS -
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }

}


// MARK:- Delegate Methods -

extension CallHistoryListViewController: CallEntryModelDelegate {
    
    func callHistoryListSucceed() {
        removeLoader()
        self.tableViewCallHistory.reloadData()
    }
    
    func apiHitFailure() {
        removeLoader()
    }
}

//MARK:- UITableViewDelegate Methods -

extension CallHistoryListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.callHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellID.callHistoryTableViewCell.rawValue, for: indexPath) as! CallHistoryTableViewCell
        cell.configureCellContent(callHistory: model.callHistory[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Did Select")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 46
    }
}

