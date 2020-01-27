//
//  DashboardViewController.swift
//  CallEntry
//
//  Created by Rajesh on 07/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit
import MessageUI
import AVFoundation


enum MessageBoardAnimation : String {
    
    case messageBoardAnimationStart = "MessageBoardAnimationStart"
    case welcomeMessage = "WelcomeMessage"
    case forEachCallCompletion = "ForEachCallCompletion"
    case firstTimeUserRecordForTheDay = "firstTimeUserRecordForTheDay"
    case breakHisPreviousRecord = "BreakHisPreviousRecord"
    case completedYourTodayTarget = "CompletedYourTodayTarget"
    case startTheUpcomingCalls = "StartTheUpcomingCalls"
    case threeMoreCallsToBreakRecord = "ThreeMoreCallsToBreakRecord"
    case threeMoreCallsToCompleteToday = "ThreeMoreCallsToCompleteToday"
    case threeMoreCallsToCompleteTodayBreakRecord = "ThreeMoreCallsToCompleteTodayBreakRecord"
    case messageBoardAnimationEnd = "MessageBoardAnimationEnd"
}


class DashboardViewController: BaseViewController {
    
    // MARK:- View Static Variables -

    // MARK:- IBOutlets -

    @IBOutlet weak var tableViewDashboardList: UITableView!
    @IBOutlet weak var lblCallsCount: UILabel!
    @IBOutlet weak var viewCallsCount: UIView!
    
    @IBOutlet weak var viewCounterBoard: UIView!
    
    @IBOutlet weak var heightConstraintForVIewCounterFilterBoard: NSLayoutConstraint!
    
    @IBOutlet weak var lblTotalCallsCount: UILabel!
    
    @IBOutlet weak var lblDeviationCallsCount: UILabel!
    
    @IBOutlet weak var lblWeek: UILabel!
    
    @IBOutlet weak var lblCallstogo         : UILabel!
    
    @IBOutlet weak var lblRecordHighScore   : UILabel!
    @IBOutlet weak var imgViewFlag          : UIImageView!
    
    @IBOutlet weak var btnMySelfFilter: UIButton!
    @IBOutlet weak var viewNoCallListFound: UIView!
    
    @IBOutlet weak var viewWishing: UIView!
    @IBOutlet weak var lblWishing: UILabel!
    @IBOutlet weak var viewScussesAlertCenterConstrains: NSLayoutConstraint!
    @IBOutlet weak var constrainsViewCallStogoTop: NSLayoutConstraint!
    
    @IBOutlet weak var viewWishesConstant: UIView!
    @IBOutlet weak var lblWishesConstant: UILabel!
    
    
    // MARK:- Properties -
    
    var dashboardListSegment: [DashboardListSegment] = []
    var model = DashboardModel()
    var showAllListSegment: [DashboardListSegment] = []
    var timerExpand = Timer()
    var timerDelay = Timer()
    var userName   = ""
    var messageBoardAlertMessage = ""
    var currentAnimation = "WelcomeMessage"
    var todayDateString : String = ""
    var isSameViewClickInMenu : Bool = false
    var callsCount : Int = 0
    
    // MARK:- View Life Cycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        model.delegate = self
        
        self.navigationController?.isNavigationBarHidden = true
    
        //if !isSameViewClickInMenu {
            
            configureViewData()
            AppCacheManager.sharedInstance().reloadDashBoard = false
       // }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if AppCacheManager.sharedInstance().reloadDashBoard {
            
            configureViewData()
            AppCacheManager.sharedInstance().reloadDashBoard = false
        }
        todayDateString = getTheCurrentDate()
        sideMenuController?.isLeftViewSwipeGestureEnabled = true
        
        if AppCacheManager.sharedInstance().isManager == "Y" {
            
            updateSalesmanRecord()
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        sideMenuController?.isLeftViewSwipeGestureDisabled = true
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    //MARK:- BUSINESS LOGICS -
    
    func configureViewData() {
        
        userName = AppCacheManager.sharedInstance().userId
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
            
            self.showLoader()
        }

        model.getCallEntryList(request: generateCallEntryListRequest())

        if AppCacheManager.sharedInstance().isManager == "Y"
        {
            heightConstraintForVIewCounterFilterBoard.constant = 53.0
             viewCounterBoard.isHidden = true
        }
        else
        {
            heightConstraintForVIewCounterFilterBoard.constant = 81.0
            viewCounterBoard.isHidden = false
            
            // time Delay for Wishing like Good morning
            
            if AppCacheManager.sharedInstance().isShown
            {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2)
                {
                    self.callsCountShown()
                    AppCacheManager.sharedInstance().isShown = false
                self.timerExpand = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(DashboardViewController.counterView), userInfo: nil, repeats: false)
                }
                if UserDefaultModel.isUserDefaultHasValue(forKey: UIConstants.UserDefaultKey.today + AppCacheManager.sharedInstance().userId)
                {
                 let date = UserDefaultModel.getDate(request: UIConstants.UserDefaultKey.date + AppCacheManager.sharedInstance().userId)
                
                    if DateExtension.equalTo(lhs: date, rhs: Date().setTime(hour: 0, min: 0, sec: 0)!)
                    {
                        print("Today date matching")
                    }
                    else
                    {
                        UserDefaultModel.updateSalesmanRecord(request: generateSalesmanRecordRequest())
                        UserDefaultModel.updateDate(request: generateSalesmanRecordRequest())
                    }
                    
                    AppCacheManager.sharedInstance().todayScore =  UserDefaultModel.getSalesmanRecord(request: UIConstants.UserDefaultKey.today + AppCacheManager.sharedInstance().userId)!
                }
                else
                {
                    UserDefaultModel.updateSalesmanRecord(request: generateSalesmanRecordRequest())
                    UserDefaultModel.updateDate(request: generateSalesmanRecordRequest())
                }
                
            }
            else
            {
               callsCountShown()
            }
        }
    }
    
    
    func callsCountShown() {
        
        callsCount = self.model.todayCalls.count
        if callsCount >= 3 {
            
            self.viewCallsCount.isHidden = false
            self.lblCallstogo.isHidden = false
            self.viewWishesConstant.isHidden = true
            self.lblCallsCount.text = "0 \(callsCount)"
            self.lblCallstogo.text = "You have only \(callsCount) more calls to complete your day."
            if callsCount == 0 {
                
                self.lblCallstogo.text = "Great day! you have completed your today's target."
            }
            //"You have \(callsCount) more calls to break you record by yourself."
            
//            if callsCount == 3 {
//
//                self.lblCallsCount.text = "\(callsCount)"
//                self.lblCallsCount.text?.insert(" ", at: (lblCallsCount.text?.index((lblCallsCount.text?.startIndex)!, offsetBy: 1))!)
//
//            } else {
//
//                self.lblCallsCount.text = "0 \(callsCount)"
//            }
           
        } else {
            
            self.viewCallsCount.isHidden = true
            self.lblCallstogo.isHidden = true
            self.showWishesAllTime()
        }
    }
    
    
    func generateCallEntryListRequest(empcode: String = "") -> GetCallEntryListRequest {
        
        let request = GetCallEntryListRequest()
        request.username = AppCacheManager.sharedInstance().userId
        request.user_token = AppCacheManager.sharedInstance().authToken
        request.Salesmancode = empcode == "" ? AppCacheManager.sharedInstance().salesmanCode : empcode
        return request
    }
    
    
    func generateShipmentListRequest(callList: Calllist) -> GetShipmentListRequest {
        
        let request = GetShipmentListRequest()
        request.username = AppCacheManager.sharedInstance().userId
        request.user_token = AppCacheManager.sharedInstance().authToken
        request.code = callList.custid
        
        return request
    }
    
    
    // generating today record
    func generateSalesmanRecordRequest() -> SalesmanRecord {
        
        let request = SalesmanRecord()
        request.userid = AppCacheManager.sharedInstance().userId
        request.score = 0
        request.key = UIConstants.UserDefaultKey.today + AppCacheManager.sharedInstance().userId
        return request
    }
    
    
    func showWishesAllTime() {
        
        let getWishDataAry = SharedPersistance().getWishesData().split(separator: "+")
        if getWishDataAry.count > 4 {
            if String(getWishDataAry[0]) == todayDateString {
                
                var wishingText = "Good Morning"
                if String(getWishDataAry[1]) == "1" {
                    
                    wishingText = "Good Morning"
                }
                if String(getWishDataAry[2]) == "1" {
                    
                    wishingText = "Good AfterNoon"
                }
                if String(getWishDataAry[3]) == "1" {
                    
                    wishingText = "Good Evening"
                }
                if String(getWishDataAry[4]) == "1" {
                    
                    wishingText = "Good Night"
                }
                
                self.lblWishesConstant.text = "\(wishingText) \(userName), have a Nice day"
                self.lblWishesConstant.font = UIFont(name: self.lblWishesConstant.font.fontName, size: 16)
            }
        }
        self.viewWishesConstant.isHidden = false
    }
    
    func updateSalesmanRecord() {
        
//        if let score = UserDefaultModel.getSalesmanRecord(request: AppCacheManager.sharedInstance().userId)
//        {
//            lblRecordHighScore.text = String(score)
//        }
//        else
//        {
//            lblRecordHighScore.text = "0"
//        }
    }
    
    
    func welcomeBoardMessage() -> Bool {
        
        let todayDateString = getTheCurrentDate()
        var isMorning   = "0"
        var isNoon      = "0"
        var isEvening   = "0"
        var isNight     = "0"
        
        let getWishDataAry = SharedPersistance().getWishesData().split(separator: "+")
        if getWishDataAry.count > 4 {
            if String(getWishDataAry[0]) == todayDateString {
                
                isMorning   = String(getWishDataAry[1])
                isNoon      = String(getWishDataAry[2])
                isEvening   = String(getWishDataAry[3])
                isNight     = String(getWishDataAry[4])
            }
        }
        
        let time = Calendar.current.component(.hour, from: Date())
        
        //self.viewCallsCount.isHidden = true
        //self.lblCallstogo.isHidden = true
        var wishingText = ""

        if time >= 1 && time < 13 {
            
            print("Good Morning")
            wishingText = "Good Morning"
            if isMorning == "1" {
                return false
            }
            isMorning = "1"
        }
        else if time >= 13 && time < 16 {
            
            print("Good afterNoon")
            wishingText = "Good AfterNoon"
            if isNoon == "1" {
                return false
            }
            isMorning = "1"
            isNoon = "1"
        }
        else if time >= 16 && time < 19 {
            
            print("Good Evening")
            wishingText = "Good Evening"
            if isEvening == "1" {
                return false
            }
            isMorning = "1"
            isNoon = "1"
            isEvening = "1"
        } else {
            
            print("Good Night")
            wishingText = "Good Night"
            if isNight == "1" {
                return false
            }
            isMorning = "1"
            isNoon = "1"
            isEvening = "1"
            isNight = "1"
        }
        
        messageBoardAlertMessage = "\(wishingText) \(userName), have a Nice day"
        self.lblWishing.font = UIFont(name: self.lblWishing.font.fontName, size: 16)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
    
            self.animateView(delayTime: 1)
        }
    
        SharedPersistance().setWishesData(data: "\(todayDateString)+\(isMorning)+\(isNoon)+\(isEvening)+\(isNight)")
        
         return true
    }
    
    
    @objc func counterView() {
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.viewCallsCount.transform = CGAffineTransform.init(scaleX: 1.25, y: 1.25)
        }) { (bool) in
            UIView.animate(withDuration: 0.5, animations: {
                self.viewCallsCount.transform = CGAffineTransform.identity
            })
        }
    }
    
    
    func textToVoiceSpeech(string : String) {
        
        let utterance = AVSpeechUtterance(string: string)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
    }
    
    
    func animateView(delayTime : Float) {
        
        lblWishing.text = messageBoardAlertMessage
        
        if viewScussesAlertCenterConstrains.constant != 0 {
            
            self.viewScussesAlertCenterConstrains.constant = 0
            self.viewWishing.isHidden = false
            self.textToVoiceSpeech(string: self.messageBoardAlertMessage)
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
                
                self.view.layoutIfNeeded()
                
            }) { _ in
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    
                    self.viewScussesAlertCenterConstrains.constant = 15
                    UIView.animate(withDuration: 0.3, delay: TimeInterval(delayTime), usingSpringWithDamping: 0.3, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
                        
                        self.view.layoutIfNeeded()
                        
                    }) { _ in
                        
                        self.viewScussesAlertCenterConstrains.constant = -41
                        UIView.animate(withDuration: 0.3, animations: {
                            
                            self.view.layoutIfNeeded()
                        }, completion: { _ in
                            
                            self.showNextMessageBoard()
                        })
                    }
                }
            }
        }
    }
    
    
    func messageBoardAnimationEnd() {
        
        self.viewWishing.isHidden = true
        self.constrainsViewCallStogoTop.constant       = 0
        UIView.animate(withDuration: 0.3, animations: {
            
            self.view.layoutIfNeeded()
        }, completion: { _ in
            
             if self.callsCount > 3 {
             
                self.showWishesAllTime()
            }
        })
    }
    
    
    func messageBoardAnimationStart() {
        
        constrainsViewCallStogoTop.constant       = -80
        UIView.animate(withDuration: 0.3, animations: {
            
            self.view.layoutIfNeeded()
        }, completion: { _ in
            
            self.showNextMessageBoard()
        })
    }
    
    
    func showNextMessageBoard() {
        
        switch currentAnimation {
            
        case MessageBoardAnimation.messageBoardAnimationStart.rawValue:
            currentAnimation = MessageBoardAnimation.welcomeMessage.rawValue
            self.messageBoardAnimationStart()
            
        case MessageBoardAnimation.welcomeMessage.rawValue:
            
            currentAnimation = MessageBoardAnimation.forEachCallCompletion.rawValue
            if !welcomeBoardMessage() {
                
                showNextMessageBoard()
            }
        case MessageBoardAnimation.forEachCallCompletion.rawValue:
            print("Data")
            currentAnimation = MessageBoardAnimation.firstTimeUserRecordForTheDay.rawValue
            let customerQuery = SharedPersistance().getCustomerQuerySuccess().split(separator: "+")
            if customerQuery.count > 1 {
                if String(customerQuery[1]) == "true" {
                    
                    messageBoardAlertMessage = "You had completed \(customerQuery[0]) query successfully."
                    SharedPersistance().setCustomerQuerySuccess(name: "\(customerQuery[0])+false")
                    self.animateView(delayTime: 3)
                    
                    return
                }
            }
            showNextMessageBoard()
            
        case MessageBoardAnimation.firstTimeUserRecordForTheDay.rawValue:
        
             currentAnimation = MessageBoardAnimation.breakHisPreviousRecord.rawValue
             
            let todayAllCall = SharedPersistance().getFirstTimeAndTodayAllCallCompleted().split(separator: "+")
            if todayAllCall.count > 2 {
                if todayAllCall[2] == "true" {
                    
                    messageBoardAlertMessage = "Your have completed \(todayAllCall[1]) calls today."
                    SharedPersistance().setFirstTimeAndTodayAllCallCompleted(todayCallCompleted: "\(todayAllCall[0])+\(0)+false")
                    self.animateView(delayTime: 1)
                    
                    return
                }
            }
            
            showNextMessageBoard()
        case MessageBoardAnimation.breakHisPreviousRecord.rawValue:
            
            currentAnimation = MessageBoardAnimation.completedYourTodayTarget.rawValue
            
            let getWishDataAry = SharedPersistance().getBreakPreviousRecord().split(separator: "+")
            if getWishDataAry.count > 2 {
                
                lblRecordHighScore.text = "\(getWishDataAry[1])"
                if getWishDataAry[1] < getWishDataAry[2] {
                    
                    messageBoardAlertMessage = "Oh great! you had break you previous record."
                    self.lblCallstogo.text = messageBoardAlertMessage
                    SharedPersistance().setBreakPreviousRecord(data: "\(getWishDataAry[0])+\(getWishDataAry[2])+0")
                    self.animateView(delayTime: 0.5)
    
                    return
                }
            }
            showNextMessageBoard()
        case MessageBoardAnimation.completedYourTodayTarget.rawValue:
            
             currentAnimation = MessageBoardAnimation.startTheUpcomingCalls.rawValue
             let getWishDataAry = SharedPersistance().getOverDueTodayCallsCompleted().split(separator: "+")
             if getWishDataAry.count > 1 {
                if getWishDataAry[1] == "true" {
                    
                    messageBoardAlertMessage = "Great day! you have completed your today's target."
                    self.lblCallstogo.text = messageBoardAlertMessage
                    SharedPersistance().setOverDueTodayCallsCompleted(data: "\(todayDateString)+false")
                    self.animateView(delayTime: 0.5)
                    return
                }
            }
             showNextMessageBoard()
        case MessageBoardAnimation.startTheUpcomingCalls.rawValue:
            
            currentAnimation = MessageBoardAnimation.threeMoreCallsToCompleteTodayBreakRecord.rawValue
            let getWishDataAry = SharedPersistance().getTakeUpCommingCall().split(separator: "+")
            if getWishDataAry.count > 1 {
                if getWishDataAry[1] == "true" {
                    
                    messageBoardAlertMessage = "Hey dude, you can take up your upcoming calls now."
                    SharedPersistance().setTakeUpCommingCall(data: "\(todayDateString)+false")
                    self.animateView(delayTime: 0.5)
                    return
                }
            }
             showNextMessageBoard()
        case MessageBoardAnimation.threeMoreCallsToCompleteTodayBreakRecord.rawValue:
            
            let getThreeMoreCall = SharedPersistance().getThreeMoreCallBreakRecord().split(separator: "+")
            if getThreeMoreCall.count > 1 {
                if getThreeMoreCall[1] == "true" {
                    let getThMoreCallToCompleteToday = SharedPersistance().getThreeMoreCallToCompleteToday().split(separator: "+")
                    if getThMoreCallToCompleteToday.count > 1 {
                        if getThMoreCallToCompleteToday[1] == "true" {
                     
                            currentAnimation = MessageBoardAnimation.messageBoardAnimationEnd.rawValue
                            messageBoardAlertMessage = "You have only 3 more calls to complete your day and break your record."
                            self.lblCallstogo.text = messageBoardAlertMessage
                            SharedPersistance().setThreeMoreCallBreakRecord(data: "\(todayDateString)+false")
                            self.animateView(delayTime: 0.5)
                            
                            return
                        }
                    }
                } else {
                    
                    currentAnimation = MessageBoardAnimation.threeMoreCallsToBreakRecord.rawValue
                    showNextMessageBoard()
                    
                    return
                }
            }
            
             currentAnimation = MessageBoardAnimation.threeMoreCallsToBreakRecord.rawValue
             showNextMessageBoard()
        case MessageBoardAnimation.threeMoreCallsToBreakRecord.rawValue:
            
            currentAnimation = MessageBoardAnimation.threeMoreCallsToCompleteToday.rawValue
            let getWishDataAry = SharedPersistance().getThreeMoreCallBreakRecord().split(separator: "+")
            if getWishDataAry.count > 1 {
                if getWishDataAry[1] == "true" {
                
                    messageBoardAlertMessage = "You have 3 more calls to break you record by yourself."
                    self.lblCallstogo.text = messageBoardAlertMessage
                    SharedPersistance().setThreeMoreCallBreakRecord(data: "\(todayDateString)+false")
                    self.animateView(delayTime: 0.5)
                    
                    return
                }
            }
             showNextMessageBoard()
        case MessageBoardAnimation.threeMoreCallsToCompleteToday.rawValue:
            
            currentAnimation = MessageBoardAnimation.messageBoardAnimationEnd.rawValue
            let getWishDataAry = SharedPersistance().getThreeMoreCallToCompleteToday().split(separator: "+")
            if getWishDataAry.count > 1 {
                if getWishDataAry[1] == "true" {
                    
                    messageBoardAlertMessage = "You have only 3 more calls to complete your day."
                    self.lblCallstogo.text = messageBoardAlertMessage
                    SharedPersistance().setThreeMoreCallToCompleteToday(data: "\(todayDateString)+false")
                    self.animateView(delayTime: 0.5)
                    
                    return
                }
            }
             showNextMessageBoard()
        case MessageBoardAnimation.messageBoardAnimationEnd.rawValue:
            
            print("NumberOfTimesCounted")
            self.messageBoardAnimationEnd()
            
            
        default:
            break
        }
    }
    
    //MARK:- BUTTON ACTIONS -
    
    @IBAction func newCallEntryButtonAction(_ sender: Any) {
        
    
        let newCallEntryViewCtrl = getViewControllerInstance(storyboardName: StoryBoardID.callEntry.rawValue, storyboardId: ViewControllerID.newCallEntryViewController.rawValue) as! NewCallEntryViewController
        newCallEntryViewCtrl.isSideMenuNavigation = false
        let navCtrl = UINavigationController(rootViewController: newCallEntryViewCtrl)

        self.present(navCtrl, animated: true, completion: nil)
        
    }
    
    @IBAction func SalesManFilterButtonAction(_ sender: Any) {
        let filterController = self.getViewControllerInstance(storyboardName: StoryBoardID.dashboard.rawValue, storyboardId: ViewControllerID.filterViewController.rawValue) as! FilterViewController
        filterController.delegate = self
        self.present(filterController, animated: true, completion: nil)
    }
    
    func navigateToShipmentHistory(code: String) {
        let shipmentHistoryViewController = getViewControllerInstance(storyboardName: StoryBoardID.customer.rawValue, storyboardId: ViewControllerID.shipmentHistoryListViewController.rawValue) as! ShipmentHistoryListViewController
        shipmentHistoryViewController.code = code
        self.navigationController?.pushViewController(shipmentHistoryViewController, animated: true)
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

//MARK:- DashboardModelDelegate Methods -

extension DashboardViewController: DashboardModelDelegate {
    
    func shipmentHistoryReceived() {
        self.removeLoader()
        
        navigateToShipmentHistory(code: model.shipment.custid)
       
    }
    
    func callListOrgalized() {
        
        self.removeLoader()
        
        currentAnimation = MessageBoardAnimation.messageBoardAnimationStart.rawValue
        self.showNextMessageBoard()
        self.callsCountShown()
        //self.timeComparision()
        
        dashboardListSegment = []
        
        if AppCacheManager.sharedInstance().isManager == "Y" {
            
            dashboardListSegment.append(.lineChart)
        }
        
        var isCallDataEmpty = true
        //Check Over Due Calls List
        if model.overDueCalls.count > 0 {
            
            dashboardListSegment.append(.overDueCalls)
            isCallDataEmpty = false
        }
        
        //Check Today's Calls List
        if model.todayCalls.count > 0 {
            
            dashboardListSegment.append(.todayCalls)
            isCallDataEmpty = false
        }
        
        //Check Upcoming Calls List
        if model.upcomingCalls.count > 0 {
            
            dashboardListSegment.append(.upcomingCalls)
            isCallDataEmpty = false
        }
        
        if model.overDueCalls.count == 0 && model.todayCalls.count == 0 {
            
            let todayDateString = getTheCurrentDate()
            let getWishDataAry = SharedPersistance().getOverDueTodayCallsCompleted().split(separator: "+")
            if getWishDataAry.count > 1 {
                if String(getWishDataAry[0]) != todayDateString {
                    
                    SharedPersistance().setOverDueTodayCallsCompleted(data: "\(todayDateString)+true")
                    SharedPersistance().setTakeUpCommingCall(data: "\(todayDateString)+true")
                }
            } else {
                
                SharedPersistance().setOverDueTodayCallsCompleted(data: "\(todayDateString)+true")
                SharedPersistance().setTakeUpCommingCall(data: "\(todayDateString)+true")
            }
        }
        
        
        if model.todayCalls.count == 3 {
            
            let todayDateString = getTheCurrentDate()
            let getWishDataAry = SharedPersistance().getThreeMoreCallToCompleteToday().split(separator: "+")
            if getWishDataAry.count > 1 {
                if String(getWishDataAry[0]) != todayDateString {
                    
                    SharedPersistance().setThreeMoreCallToCompleteToday(data: "\(todayDateString)+true")
                }
            } else {
                
                SharedPersistance().setThreeMoreCallToCompleteToday(data: "\(todayDateString)+true")
            }
        }
        
        let todayDateString = getTheCurrentDate()
        let todayAllCall = SharedPersistance().getFirstTimeAndTodayAllCallCompleted().split(separator: "+")
        if todayAllCall.count > 2 {
            if String(model.todayCalls.count) > todayAllCall[1] {
                
                SharedPersistance().setFirstTimeAndTodayAllCallCompleted(todayCallCompleted: "\(todayDateString)+\(model.todayCalls.count)+false")
            }
        } else if model.todayCalls.count != 0 {
            
            SharedPersistance().setFirstTimeAndTodayAllCallCompleted(todayCallCompleted: "\(todayDateString)+\(model.todayCalls.count)+false")
        }
        
        if model.todayCalls.count == 0 {
            
            if todayAllCall.count > 2 {
                if String(todayAllCall[1]) != "0"  {
                    
                    SharedPersistance().setFirstTimeAndTodayAllCallCompleted(todayCallCompleted: "\(todayDateString)+\(todayAllCall[1])+true")
                }
            }
        }
        
        
        viewNoCallListFound.isHidden = !isCallDataEmpty
        self.tableViewDashboardList.reloadData()
    }
    
    func apiHitFailure() {
        self.removeLoader()
        print("API Hit Failure")
    }
}


//MARK:- DashboardTableViewCellDelegate Methods -

extension DashboardViewController: DashboardTableViewCellDelegate {
    func shipmentHistoryAction(callList: Calllist) {
      
        navigateToShipmentHistory(code: callList.custid)
       // model.getShipmentList(request: generateShipmentListRequest(callList: callList))
    }
}

//MARK:- UITableViewDelegate Methods -

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return dashboardListSegment.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        switch dashboardListSegment[indexPath.section] {
            
        case .lineChart:
            
             let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellID.dashboardLineChartTableViewCell.rawValue, for: indexPath) as! DashboardLineChartTableViewCell
             cell.delegate = self
             cell.lineChartData = model.lineChartData
             self.showAllListSegment.append(.lineChart)
             
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellID.dashboardTableViewCell.rawValue, for: indexPath) as! DashboardTableViewCell
            cell.delegate = self
            cell.dashboardViewController = self
            cell.summaryDelegate = self
            cell.showallDelegate = self
            cell.delegateCallMail = self
            cell.btnShowall.tag = indexPath.section
            
            switch dashboardListSegment[indexPath.section]
            {
            case .overDueCalls:
                cell.segmentType = .overDueCalls
                cell.overDueCalls = model.overDueCalls
                cell.calls = []
                self.showAllListSegment.append(.overDueCalls)
                
            case .todayCalls:
                cell.segmentType = .todayCalls
                cell.calls = model.todayCalls
                cell.overDueCalls = []
                self.showAllListSegment.append(.todayCalls)
                
            case .upcomingCalls:
                cell.segmentType = .upcomingCalls
                cell.calls = model.upcomingCalls
                cell.overDueCalls = []
                self.showAllListSegment.append(.upcomingCalls)
                
            default:
                print("Hypothetical Case")
                cell.segmentType = .none
                 cell.overDueCalls = []
                cell.calls = []
            }
            
            cell.configureCellContent()
            
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch dashboardListSegment[indexPath.section]
        {
        case .lineChart:
            return 197.0
        default:
            return 231.0
        }
    }
}

extension DashboardViewController: SummaryPageDelegate {
    func tickGreenAction(callList: Calllist)
    {
        print("SummaryController")
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

extension DashboardViewController: showAllButtonActionDelegate {
    func showAllButtonAction(sender: AnyObject, btnSection : Int) {
        print("ShowallController")
       
        let showAllCallListController = self.getViewControllerInstance(storyboardName: StoryBoardID.dashboard.rawValue, storyboardId: ViewControllerID.showAllCallListViewController.rawValue) as! ShowAllCallListViewController
        showAllCallListController.dashListSegment = self.showAllListSegment
        showAllCallListController.todayCalls = model.todayCalls
        showAllCallListController.upcomingCalls = model.upcomingCalls
        showAllCallListController.allOverDueCalls = model.overDueCalls
        
//        if let button = sender as? UIButton
//        {
//            if let superview = button.superview {
//                if let cell = superview.superview as? DashboardTableViewCell {
//                   let indexPath = tableViewDashboardList.indexPath(for: cell)! as NSIndexPath
//                    showAllCallListController.selection = indexPath.section
//                }
//            }
//        }
        showAllCallListController.selection = btnSection
        self.navigationController?.pushViewController(showAllCallListController, animated: true)
    }
}

extension DashboardViewController: CallMailDelegate,MFMailComposeViewControllerDelegate
{
    
    func CallMail(calllist: Calllist)
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

// calculating the total call and overdue call count for showing in top View

extension DashboardViewController: ScrollDelegate {
    func nextChartUpdate(chartNo: Int)
    {
        switch chartNo {
        case 0:
            lblWeek.text = "Last Week"
            lblTotalCallsCount.text = String(model.lineChartData[0].weekDays.map( {$0.totalCallCount} ).reduce(0, { $0 + $1})) + " Calls"
            lblDeviationCallsCount.text = String(model.lineChartData[0].weekDays.map({ $0.deviationCallCount}).reduce(0, { $0 + $1})) + " Deviation Calls"
            
        default:
            lblWeek.text = "Upcoming Week"
            lblTotalCallsCount.text = String(model.lineChartData[1].weekDays.map( {$0.totalCallCount} ).reduce(0, { $0 + $1})) + " Calls"
            lblDeviationCallsCount.text = "0 Deviation Calls"
        }
    }
}

extension DashboardViewController: SelectedSalesmanDelegate {
    
    func selectedSalesman(empcode: Salesmanlist) {
        print("employee code passed")
        
        btnMySelfFilter.setTitle(AppCacheManager.sharedInstance().salesmanCode == empcode.code ? "Myself" : empcode.name, for: .normal)
        model.getCallEntryList(request: generateCallEntryListRequest(empcode: empcode.code))
    }
}

