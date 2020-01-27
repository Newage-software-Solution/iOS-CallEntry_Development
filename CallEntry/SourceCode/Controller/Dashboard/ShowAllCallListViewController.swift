//
//  ShowAllCallListViewController.swift
//  CallEntry
//
//  Created by Rajesh on 07/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit
import MessageUI

class ShowAllCallListViewController: BaseViewController {
    
    // MARK:- View Static Variables -
    
    // MARK: - View Dynamic Variables -
    
    var selection: Int = 0
    var allOverDueCalls: [OverDueCallList] = []
    var todayCalls: [Calllist] = []
    var upcomingCalls: [Calllist] = []
    var dashListSegment: [DashboardListSegment] = []
    
    // MARK:- IBOutlets -
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!
    
    // MARK:- Properties -
    
    // MARK:- View Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewData()
         print(dashListSegment)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- BUSINESS LOGICS -
    
    func configureViewData() {
        collection.register(UINib(nibName: "CustomerCallsboxCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomerCell")
        
//        let collectionViewLayout = UICollectionViewFlowLayout()
//        collectionViewLayout.minimumInteritemSpacing = 10
//        collectionViewLayout.minimumLineSpacing = 10
//        collectionViewLayout.scrollDirection = .vertical
//
//        collectionViewLayout.itemSize = UIDevice.current.userInterfaceIdiom == .pad ? CGSize(width: 356,height: 161) : CGSize(width: UIScreen.main.bounds.width - 40 ,height: 162)
//        collection.collectionViewLayout = collectionViewLayout
    }
    
    //MARK:- BUTTON ACTIONS -
    
    @IBAction func backButtonAction(_ sender: Any)
    {  
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
extension ShowAllCallListViewController: UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        switch dashListSegment[selection]
        {
        case .overDueCalls:
            return allOverDueCalls.count
        case .todayCalls:
            return todayCalls.count
        case .upcomingCalls:
            return upcomingCalls.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomerCell", for: indexPath) as! CustomerCallsboxCollectionViewCell
        cell.delegate = self
        cell.summarydelegate = self
        cell.delegateCall_Mail = self
        if dashListSegment[selection] == .overDueCalls
        {
            let overDueCallInfo = allOverDueCalls[indexPath.item]
            cell.configureCellContent(callList: overDueCallInfo.calllist, deviationDays: overDueCallInfo.overDueDaysNo)
            self.lblTitle.text = "Overdue calls(\(allOverDueCalls.count))"
        }
        else if dashListSegment[selection] == .todayCalls
        {
             cell.configureCellContent(callList: todayCalls[indexPath.item], deviationDays: 0)
             self.lblTitle.text = "Today's calls(\(todayCalls.count))"
        }
        else
        {
            cell.configureCellContent(callList: upcomingCalls[indexPath.item], deviationDays: 0,isUpcomingCalls: true)
            self.lblTitle.text = "Upcoming calls(\(upcomingCalls.count))"
        }
        cell.layer.cornerRadius = 9
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1).cgColor
         return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let callEntryDetailViewController = getViewControllerInstance(storyboardName: StoryBoardID.callEntry.rawValue, storyboardId: ViewControllerID.callEntryDetailViewController.rawValue) as! CallEntryDetailViewController
        switch dashListSegment[selection]
        {
        case .overDueCalls:
             callEntryDetailViewController.callDetail = allOverDueCalls[indexPath.item].calllist
        case .todayCalls:
             callEntryDetailViewController.callDetail = todayCalls[indexPath.item]
        case .upcomingCalls:
             callEntryDetailViewController.callDetail = upcomingCalls[indexPath.item]
        default: break
            
        }
        self.navigationController?.pushViewController(callEntryDetailViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        return CGSize(width: (UIScreen.main.bounds.width), height: 155.0 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0.0
    }
    
}

extension ShowAllCallListViewController: CustomerCallsboxCollectionViewCellDelegate {
    func shipmentHistoryClicked(callList: Calllist) {
        print("shipmentController")
        
      let shipmentController = self.getViewControllerInstance(storyboardName: StoryBoardID.customer.rawValue, storyboardId: ViewControllerID.shipmentHistoryListViewController.rawValue) as! ShipmentHistoryListViewController
        shipmentController.code = callList.custid
        self.navigationController?.pushViewController(shipmentController, animated: true)
    }
}

extension ShowAllCallListViewController: SummaryPageNavigateDelegate {
    func tickImageClicked(callList: Calllist) {
        print("summaryController")
        
        let summaryController = self.getViewControllerInstance(storyboardName: StoryBoardID.summary.rawValue, storyboardId: ViewControllerID.newSummaryViewController.rawValue) as! NewSummaryViewController
        if let customerdetail = DataBaseModel.getCustomerDetailForID(cusId: callList.custid)
        {
            summaryController.customerDetail = customerdetail
            summaryController.followupNo = callList.followups.count + 1
        }
        summaryController.callId = callList.callid
        
        self.navigationController?.pushViewController(summaryController, animated: true)
        
    }
}

extension ShowAllCallListViewController: CallandMailDelegate,MFMailComposeViewControllerDelegate
{
    
    func callandMail(calllist: Calllist)
    {
        let customerDetail = DataBaseModel.getCustomerDetailForID(cusId: calllist.custid)
        
        if calllist.followups[0].mode.uppercased() == "PHONE"
        {
            if isValidMobileNumber(mobileNo: (customerDetail?.phoneno)!)
            {
                self.phoneCalling(phoneNo: (customerDetail?.phoneno)!)
            }
            else
            {
                self.showAlertMessage(message: AlertMessages.Message.phoneNoInvalid)
            }
        }
        else
        {
            if isValidEmail(emailAddress: (customerDetail?.emailid)!)
            {
                if MFMailComposeViewController.canSendMail()
                {
                    let mailComposer = MFMailComposeViewController()
                    mailComposer.mailComposeDelegate = self
                    mailComposer.setToRecipients([(customerDetail?.emailid)!])
                    self.present(mailComposer, animated: true, completion: nil)
                }
            }
            else
            {
                self.showAlertMessage(message: AlertMessages.Message.invalidEmailId)
            }
            
        }
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

