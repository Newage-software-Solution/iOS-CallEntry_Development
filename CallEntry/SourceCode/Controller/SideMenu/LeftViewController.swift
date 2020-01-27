//
//  LeftViewController.swift
//  LGSideMenuControllerDemo
//

import UIKit
import LGSideMenuController.LGSideMenuController
import LGSideMenuController.UIViewController_LGSideMenuController

class LeftViewController: BaseViewController {
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var tableViewLeftMenu: UITableView!
    @IBOutlet weak var headerView: UIView!
    
    var selectedIndexPath = IndexPath(row: 0, section: 0)
    var previosSelectedIndexPath = IndexPath(row: 0, section: 0)
    
    var model = SideMenuModel()
    
    let titlesArray = ["DASHBOARD", "NEW CALL ENTRY", "CUSTOMERS", "PRE CALL PLANNER", "MY PROFILE","SALES MEET 2019", "LOGOUT"]
    let imageArray = ["dashboard", "newCallEntry", "customer", "preCallPlanner", "myProfile","Salesmeet", "logout"]
  
    override func viewDidLoad() {
        super.viewDidLoad()
        model.delegate = self
        lblUserName.text = AppCacheManager.sharedInstance().userDetail.name.capitalizingFirstLetter()
        loadImageForUrl(AppCacheManager.sharedInstance().userDetail.picture)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if let touch = touches.first {
            if touch.view == self.headerView { //image View property
                self.tapDetected()
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    
    func loadImageForUrl(_ urlString: String) {
        
        if let imageUrl = URL(string: urlString)
        {
            DispatchQueue.global(qos: .userInitiated).async {
                
                do
                {
                    let imageData = try Data(contentsOf: imageUrl)
                    
                    DispatchQueue.main.async {
                        self.imageViewProfile.image = UIImage(data: imageData)
                    }
                }
                catch(let error)
                {
                    print(error)
                }
            }
        }
    }
    // generating Logout Request
    
    func generatelogoutRequest() -> LogoutRequest
    {
        let request = LogoutRequest()
        request.userid = AppCacheManager.sharedInstance().userId
        request.usertoken = AppCacheManager.sharedInstance().authToken
        return request
    }
    
    @objc func tapDetected() {
        let mainViewController = sideMenuController!
        let navigationController = mainViewController.rootViewController as! NavigationController
        var viewControllerID: String = ""
        var storyboardID: String = ""
        
        viewControllerID = ViewControllerID.profileViewController.rawValue
        storyboardID = StoryBoardID.userAccount.rawValue
        
        let storyboard = UIStoryboard(name: storyboardID, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerID)
        
        navigationController.setViewControllers([viewController], animated: false)
        
        mainViewController.hideLeftView(animated: true, completionHandler: nil)
        
        selectedIndexPath = IndexPath(row: 4, section: 0)
    }
    
    // Navigate to Login page when User Logout pressed
    
    func navigatetoLogin()
    {
        if let mainViewController = self.sideMenuController
        {
            UserDefaultModel.removeUserDefaultValue(forKey: UIConstants.UserDefaultKey.userInfo)
            
//            let storyboard = UIStoryboard(name: StoryBoardID.sideMenu.rawValue, bundle: nil)
//            let navigationController = storyboard.instantiateViewController(withIdentifier: ViewControllerID.navigationController.rawValue) as! UINavigationController
//
//            let mainStoryboard =  UIStoryboard(name: StoryBoardID.userAccount.rawValue, bundle: nil)
//
//            navigationController.setViewControllers([mainStoryboard.instantiateViewController(withIdentifier: ViewControllerID.loginViewController.rawValue)], animated: false)
//
//            let mainViewController = storyboard.instantiateInitialViewController() as! MainViewController
//            mainViewController.rootViewController = navigationController
            
            self.navigationController?.popViewController(animated: true)
            
        }
    }
    
    func showAlertMessageWithTwoButton(message : String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        let yesHandler = UIAlertAction(title: "Yes", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Yes Pressed")
            self.model.logoutAccount(request: self.generatelogoutRequest())
            UserDefaults.standard.set("", forKey: "SavedStringArray")
        }
        
        let noHandler = UIAlertAction(title: "No", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("No Pressed")
            
            if let mainViewController = self.sideMenuController
            {
                //Deselect logout Menu
                self.tableView(self.tableViewLeftMenu, didDeselectRowAt: IndexPath(row: self.titlesArray.index(of: "LOGOUT")!, section: 0))

                //Select Previously Selected Menu
                let selectedCell = self.tableViewLeftMenu.cellForRow(at: self.selectedIndexPath) as! LeftViewCell
                selectedCell.configureCellSelection(isSelected: true , image : self.imageArray[self.selectedIndexPath.row] + "Select")

                mainViewController.hideLeftView(animated: true, completionHandler: nil)
            }

        }
        
        alertController.addAction(yesHandler)
        alertController.addAction(noHandler)
        self.present(alertController, animated: true, completion: nil)
    }
}

//delegate
extension LeftViewController: SideMenuModelDelegate
{
    func apiHitSuccess() {
        print("Logout Successfully")
        
        let todayDateString = getTheCurrentDate()
        SharedPersistance().setWishesData(data: "\(todayDateString)+0+0+0+0")
        navigatetoLogin()
    }
    
    func apiHitFailure() {
        self.showAlertMessage(message: AlertMessages.Message.logoutFail)
    }
}

// MARK: - UITableViewDelegate

extension LeftViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LeftViewCell
        
        cell.lblMenu.text = titlesArray[indexPath.row]
        
        if indexPath ==  selectedIndexPath
        {
            cell.configureCellSelection(isSelected: true , image : imageArray[indexPath.row] + "Select")
        }
        else
        {
            cell.configureCellSelection(isSelected:  false, image : imageArray[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  53.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Deselect Previous Selected Cell
         self.tableView(tableView, didDeselectRowAt: selectedIndexPath)
        
        //Update Current Cell Selection
        let selectedCell = tableView.cellForRow(at: indexPath) as! LeftViewCell
        selectedCell.configureCellSelection(isSelected: true , image : imageArray[indexPath.row] + "Select")

        if titlesArray[indexPath.row] == "LOGOUT"
        {
            self.showAlertMessageWithTwoButton(message: AlertMessages.Message.logout)
            
        }
//        } else if titlesArray[indexPath.row] == "PRE CALL PLANNER"
//        {
//            selectedIndexPath = previosSelectedIndexPath
//            self.showAlertMessage(message: AlertMessages.Message.preCallPlannerAlert)
//        }
        else
        {
            //Navigate to Selected Menu Page
            let mainViewController = sideMenuController!
            let navigationController = mainViewController.rootViewController as! NavigationController
            var viewControllerID: String = ""
            var storyboardID: String = ""
            
            switch titlesArray[indexPath.row] {
            case "DASHBOARD":
                viewControllerID = ViewControllerID.dashboardViewController.rawValue
                storyboardID = StoryBoardID.dashboard.rawValue
                
            case "NEW CALL ENTRY":
                viewControllerID = ViewControllerID.newCallEntryViewController.rawValue
                storyboardID = StoryBoardID.callEntry.rawValue
            case "CUSTOMERS":
                viewControllerID = ViewControllerID.customerListViewController.rawValue
                storyboardID = StoryBoardID.customer.rawValue
            case "PRE CALL PLANNER":
                viewControllerID = ViewControllerID.preCallPlannerListViewController.rawValue
                storyboardID = StoryBoardID.callEntry.rawValue
            case "SALES MEET 2019":
                viewControllerID = ViewControllerID.salesmeetItemsViewController.rawValue
                storyboardID = StoryBoardID.salesmeet.rawValue
            case "MY PROFILE":
                viewControllerID = ViewControllerID.profileViewController.rawValue
                storyboardID = StoryBoardID.userAccount.rawValue
            default:
                print("Selection Not Match")
            }
            
            let storyboard = UIStoryboard(name: storyboardID, bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerID)
            if viewControllerID == ViewControllerID.dashboardViewController.rawValue {
                if let view = viewController as? DashboardViewController {
                    view.isSameViewClickInMenu = selectedIndexPath == indexPath ? true : false
                }
            }
            navigationController.setViewControllers([viewController], animated: false)
            
            mainViewController.hideLeftView(animated: true, completionHandler: nil)
            
            selectedIndexPath = indexPath
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let deselectedCell = tableView.cellForRow(at: indexPath) as! LeftViewCell
        deselectedCell.configureCellSelection(isSelected: false , image : imageArray[indexPath.row])
    }

    
   
//    let menu = SelectedMenu()
//    menu.name = titlesArray[indexPath.row]
//    menu.index = indexPath.row
//
//    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationCenterKey.sideMenuOptions.rawValue), object: menu)
//
//    self.tableView(tableView, didDeselectRowAt: selectedIndexPath)
}

