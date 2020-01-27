//
//  PreCallPlannerListViewController.swift
//  CallEntry
//
//  Created by Rajesh on 07/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit
import MessageUI
class PreCallPlannerListViewController: BaseViewController {
    
    // MARK:- View Static Variables -
    
    // MARK:- IBOutlets -
    
    @IBOutlet weak var btnMail: UIButton!
    @IBOutlet weak var lblNoListAvailable: UILabel!
    @IBOutlet weak var collection: UICollectionView!
    // MARK:- Properties -
    fileprivate var PrecallPlannarListcolumns: String =  "No,Customer,Category,ispotentialclient,Followup action,Followup date,Call Mode,Phoneno/Address/Emailid,Segment,Type,Period,Origin,Destination,TOS,Commodity group,No of Shipmenets,Volume,Business Status,Estimated revenue,Closure date\n"
    
    var model = CallEntryModel()
    var customerList: [Customerlist] = []
    // MARK:- View Life Cycle -
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        model.delegate = self
        lblNoListAvailable.text = AlertMessages.Message.preCallPlannerAlert
        self.btnMail.isHidden = true
        //configureViewData()
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
            
            self.showLoader()
        }
        collection.register(UINib(nibName: "PreCallPlannerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.minimumInteritemSpacing = 10
        collectionViewLayout.minimumLineSpacing = 10
        collectionViewLayout.scrollDirection = .vertical
        
        collectionViewLayout.itemSize = UIDevice.current.userInterfaceIdiom == .pad ? CGSize(width: 356,height: 133) : CGSize(width: UIScreen.main.bounds.width - 40 ,height: 133)
        collection.collectionViewLayout = collectionViewLayout
        model.preCallPlannerList(request: getPrecallPlannerRequest())
    }
    
    func getPrecallPlannerRequest() -> PreCallPlannerListRequest
    {
        let request = PreCallPlannerListRequest()
        request.userid = AppCacheManager.sharedInstance().userId
        request.usertoken = AppCacheManager.sharedInstance().authToken
        return request
    }
    
    // Calculation for customerList based on the custid from preCallPlanner List
    func customerListCalculation()
    {
        for i in 0 ..< model.preCallPlannerList.count
        {
            for j in 0 ..< AppCacheManager.sharedInstance().customerList.count
            {
            if model.preCallPlannerList[i].custid == AppCacheManager.sharedInstance().customerList[j].custid
            {
                self.customerList.append(AppCacheManager.sharedInstance().customerList[j])
            }
            }
        }
    }
    
    
    //MARK:- BUTTON ACTIONS -
    @IBAction func mailButtonAction(_ sender: Any)
    {
        mail()
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
extension PreCallPlannerListViewController:  CallEntryModelDelegate
{
    func precallPlannerListReceiverd()
    {
        print("PreCallPlannerListReceived")
        self.customerListCalculation()
        self.collection.reloadData()
        self.removeLoader()
    }
    
    func apiHitFailure() {
        print("Precall plannar Hit Failure")
        self.removeLoader()
    }
}

extension PreCallPlannerListViewController: UICollectionViewDataSource,UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return model.preCallPlannerList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PreCallPlannerCollectionViewCell
        
        cell.configureCellData(preCallPlannerList: model.preCallPlannerList[indexPath.row], customerList: self.customerList[indexPath.row])
        return cell
    }
}

extension PreCallPlannerListViewController: MFMailComposeViewControllerDelegate
{
    
    func mail()
    {
        if( MFMailComposeViewController.canSendMail() )
        {
            print("Can send email.")
            
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            
            //Set the subject and message of the email
            mailComposer.setToRecipients(["alpha@mailinator.com"])
            mailComposer.setSubject("Pre call Planner list")
            mailComposer.setMessageBody("This is From Call Entry Application", isHTML: false)
            
            // Creating the CSV file
            let fileName = "PreCallPlanner.csv"
            let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
            
            self.getXLData()
            
            do
            {
                try PrecallPlannarListcolumns.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
            }
            catch
            {
                print("Failed to create file")
                print("\(error)")
            }
            
                if let fileData = NSData(contentsOf: path!)
                {
                    print("File data loaded.")
                    mailComposer.addAttachmentData(fileData as Data, mimeType: "text/csv", fileName: "PreCallPlanner.csv")
                }
            self.present(mailComposer, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
}

// precallplannar XL Filling

extension PreCallPlannerListViewController
{
    func getXLData()
    {
        var mode: String = ""
        for i in 0 ..< model.preCallPlannerList.count
        {
            switch model.preCallPlannerList[i].followups[0].mode.uppercased()
            {
            case "VISIT":
                mode = customerList[i].address + " " + customerList[i].city
            case "CALL":
                mode = customerList[i].phoneno
            case "MAIL":
                mode = customerList[i].emailid
            default:
                mode = ""
            }
            let newline = "\(i+1),\(customerList[i].name),HR & Recruitment,\(model.preCallPlannerList[i].ispotentialclient),\(model.preCallPlannerList[i].followups.first?.action ?? ""),\(model.preCallPlannerList[i].followups.first?.followupdate ?? ""),\(model.preCallPlannerList[i].followups[0].mode),\(mode),"
            
             PrecallPlannarListcolumns.append(contentsOf: newline)
            
            for j in 0 ..< customerList[i].profile.count
            {
                var profile = ",\(customerList[i].profile[j].segment),\(customerList[i].profile[j].type),\(customerList[i].profile[j].period),\(customerList[i].profile[j].origin),\(customerList[i].profile[j].destination),\(customerList[i].profile[j].tos),\(customerList[i].profile[j].commoditygroup),\(customerList[i].profile[j].noofshipments),\(customerList[i].profile[j].volume),\(customerList[i].profile[j].currentpotential),\(customerList[i].profile[j].estimatedrevenue),\(customerList[i].profile[j].closuredate)\n"
                if j != 0
                {
                     profile = ", , , , , , , ," + profile
                }
                PrecallPlannarListcolumns.append(contentsOf: profile)
            }
           
        }
    }
}

