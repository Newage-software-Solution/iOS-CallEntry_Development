//
//  ShipmentHistoryListViewController.swift
//  CallEntry
//
//  Created by Rajesh on 07/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

class ShipmentHistoryListViewController: BaseViewController {
    
    // MARK:- View Static Variables -
    var lastShipmentList: [Lastshipment]!

    var shipmentHistoryList: [History] = []
    
    var shipment: Shipment! = Shipment()
    
    var code: String = ""
    
    var model = DashboardModel()

    // MARK:- IBOutlets -
    
    @IBOutlet weak var tbleView: UITableView!
    
    @IBOutlet weak var lblNodataFound: UILabel!
    
    // MARK:- Properties -
    
    // MARK:- View Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.delegate = self
        configureViewData()
        self.showLoader()
        model.getShipmentList(request: getShipmentRequest())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- BUSINESS LOGICS -
    
    func getShipmentRequest() -> GetShipmentListRequest {
        let obj = GetShipmentListRequest()
       obj.code = code
        obj.username = AppCacheManager.sharedInstance().userId
        obj.user_token = AppCacheManager.sharedInstance().authToken
        return obj
    }
    
    func configureViewData() {
        
        tbleView.register(UINib.init(nibName: "shipmentHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    //MARK:- BUTTON ACTIONS -
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
extension ShipmentHistoryListViewController: UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
//        if shipmentHistoryList != nil
//        {
//            return shipmentHistoryList.count
//        }
//        else if lastShipmentList != nil
//        {
//            return lastShipmentList.count
//        }
        
        return shipmentHistoryList.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let shipmentListHistoryCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! shipmentHistoryTableViewCell
       
        shipmentListHistoryCell.contentView.layer.cornerRadius = 9
        shipmentListHistoryCell.contentView.layer.borderWidth = 1
        shipmentListHistoryCell.contentView.layer.borderColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1).cgColor
        shipmentListHistoryCell.contentView.clipsToBounds = true
        
        if shipmentHistoryList != nil
        {
            shipmentListHistoryCell.configureCellDataWithHistory(shipment: self.shipmentHistoryList[indexPath.section])
        }
        else if lastShipmentList != nil
        {
            shipmentListHistoryCell.configureCellDataWithLastShipment(shipment: self.lastShipmentList[indexPath.section])

        }
        
        return shipmentListHistoryCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 11
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 0.05)
        return header
    }
    
}
extension ShipmentHistoryListViewController: DashboardModelDelegate {
    func shipmentHistoryReceived(){
        print("shipment details received")
        shipmentHistoryList = model.shipment.history
        lblNodataFound.isHidden = shipmentHistoryList.count == 0 ? false : true
        self.removeLoader()
        self.tbleView.reloadData()
    }
    func callListOrgalized() {
        
    }
    func apiHitFailure() {
        self.removeLoader()
    }
}

