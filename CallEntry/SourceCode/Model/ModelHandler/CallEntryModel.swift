//
//  CallEntryModel.swift
//  CallEntry
//
//  Created by Rajesh on 07/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

@objc protocol CallEntryModelDelegate {
    @objc optional func shipmentHistoryReceived()
    @objc optional func apiHitFailure()
    @objc optional func precallPlannerListReceiverd()
    @objc optional func newCallEnterDataAddedSuccess()
    @objc optional func callHistoryListSucceed()
}

class CallEntryModel: BaseModel {

    var delegate: CallEntryModelDelegate?
    
    var shipment: Shipment!
    
    var preCallPlannerList: [Calllist] = []
    
    var callHistory: [Callhistory] = []
    
    func getCallEntryList(request: GetCallEntryListRequest) {
        
    }
    
    func newCallEntry(request: NewCallEntryRequest) {
        
        CallEntryDataHandler().newCallEntry(request: request) { (response, error) in
            if let responseData = response
            {
                self.delegate?.newCallEnterDataAddedSuccess?()
            }
            else if let errorData = error
            {
                self.showFailureMessage(error: errorData as NSError)
                self.delegate?.apiHitFailure!()
            }
        }
    }
    
    func updateCallEntry(request: UpdateCallEntryRequest) {
        
    }
    
    func preCallPlannerList(request: PreCallPlannerListRequest) {
        
        CallEntryDataHandler().preCallPlannerList(request: request) { (response, error) in
           if let responseData = response
           {
            self.preCallPlannerList = responseData.calllist
            self.delegate?.precallPlannerListReceiverd!()
        }
            else if let errorData = error
           {
            self.showFailureMessage(error: errorData as NSError)
            self.delegate?.apiHitFailure!()
        }
    }
    }
    
    func getCallHistoryList(request: CallhistoryRequest) {
        
        CallEntryDataHandler().getCallhistoryList(request: request) { (response, error) in
            
            if let responseData = response
            {
                self.callHistory = responseData.customerlist.first?.callhistory ?? []
                self.delegate?.callHistoryListSucceed?()
            }
            else if let errorData = error
            {
                self.showFailureMessage(error: errorData as NSError)
                self.delegate?.apiHitFailure!()
            }
            
        }
    }
    
    //MARK:- Business Logics
    
    func getSubcategoryListForCategory(_ category: String) -> [String] {
        
        var arrayIndex: Int = 0
        
        for i in 0 ..< AppCacheManager.sharedInstance().masterData.calltype.count
        {
            if AppCacheManager.sharedInstance().masterData.calltype[i].categoryname.localizedLowercase == category.localizedLowercase
            {
                arrayIndex = i
            }
        }
        let subCategory = AppCacheManager.sharedInstance().masterData.calltype[arrayIndex].subcategory.map( { $0.name } )
        
        
        return subCategory
    }
    
    func getFollowupAction(followupAct: [Id]) -> [String]
    {
        var followup: [String] = []
       for i in followupAct
       {
        followup.append(i.name)
        }
        return followup
    }
    
    func getFollowupActionId(followupAct: [Id], name : String) -> String
    {
        //var followup : String = ""
        if let idValue = (followupAct.filter( { $0.name == name.uppercased() } ).first) {
            
            return idValue.code
        }
        return ""
    }
    
    func getShipmentList(request: GetShipmentListRequest) {
         CallEntryDataHandler().getShipmentList(request: request, Completion: {(response, error) in
            
            if let errorData = error
            {
                self.showFailureMessage(error: errorData as NSError)
                self.delegate?.apiHitFailure?()
            }
            else if let responseData = response
            {                
                if responseData.statuscode == "200"
                {
                    self.shipment = responseData.shipments
                    self.delegate?.shipmentHistoryReceived?()
                }
            }
        })
    }
    
    func shipmentHistoryList() -> [Lastshipment] {
        
        let shipment1 = Lastshipment()
        
        shipment1.shipmentno = "Shipment #1254685566"
        shipment1.date = "1/1/2018"
        shipment1.origin = "DUBAI"
        shipment1.destination = "CHENNAI"
        shipment1.etd = "15/1/2018"
        shipment1.eta = "25/2/2018"
        shipment1.bookingperson = "sukumar"
        shipment1.segment = "AIR"
        shipment1.update = "Shipments moved from the singapore"
        
        let shipment2 = Lastshipment()
        shipment2.shipmentno = "Shipment #190101702528"
        shipment2.date = "10/1/2018"
        shipment2.origin = "Canada"
        shipment2.segment = "FCL"
        shipment2.destination = "CHENNAI"
        shipment2.etd = "20/1/2018"
        shipment2.eta = "25/3/2018"
        shipment2.bookingperson = "Ithaya kumar"
        shipment2.update = "Cargo clearance in kuwaith"
        
        return [shipment1,shipment2]
    }
    
    func getProfileList() -> [Profile]{
        
        let profile = Profile()
        profile.profileid = "101"
        profile.segment = "Air"
        profile.commoditygroup = ""
        profile.destination = "CHENNAI"
        profile.noofshipments = "12"
        profile.origin = "DUBAI"
        profile.period = "Monthly"
        profile.tos = "FOB"
        profile.type = "Import"
        profile.volume = "550"
        
        let profile1 = Profile()
        profile1.profileid = "102"
        profile1.segment = "FCL"
        profile1.commoditygroup = ""
        profile1.destination = "CANADA"
        profile1.noofshipments = "22"
        profile1.origin = "CHENNAI"
        profile1.period = "Weekly"
        profile1.tos = "FOB"
        profile1.type = "Export"
        profile1.volume = "670"
        
        return [profile, profile1]
    }
    
}
