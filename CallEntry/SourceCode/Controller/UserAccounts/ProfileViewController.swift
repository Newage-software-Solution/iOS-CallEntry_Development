//
//  ProfileViewController.swift
//  CallEntry
//
//  Created by Rajesh on 07/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {
    
    // MARK:- View Static Variables -
    let titles = ["Name","Email ID","Phone No"]
    // MARK:- IBOutlets -
    
    @IBOutlet weak var tbleView: UITableView!
    // MARK:- Properties -
    
    // MARK:- View Life Cycle -
    let userDetail = AppCacheManager.sharedInstance().userDetail
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewData()
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
    
    func configureViewData()
    {
    self.tbleView.register(UINib(nibName: "NewCustomerEntryListTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    self.tbleView.register(UINib(nibName: "NewCustomerEntryProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "lastcell")
        tbleView.tableFooterView = UIView()
    }
    
    //MARK:- BUTTON ACTIONS -
    
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
extension ProfileViewController: UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "myProfileCell", for: indexPath) as! MyProfileTableViewCell
            cell.configureData(url: userDetail.picture)
            
            return cell
        
        } else if indexPath.row < 3 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NewCustomerEntryListTableViewCell
            
            cell.lblTop.text = titles[indexPath.row]
            cell.imgArrow.isHidden = true
            cell.txtfldBottom.text = indexPath.row == 0 ? userDetail.name : indexPath.row == 1 ? userDetail.emailid : userDetail.phoneno
            cell.textViewinput.isHidden = true
            cell.isUserInteractionEnabled = false
            cell.viewSeperator.isHidden = false
            cell.txtfldBottom.font = UIFont(name: "Roboto-Regular", size: 15.0)
            
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "lastcell", for: indexPath) as! NewCustomerEntryProfileTableViewCell
    
            cell.configureData()
            
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 && indexPath.row == 3 {
            
            let changePasswordController = self.getViewControllerInstance(storyboardName: StoryBoardID.userAccount.rawValue, storyboardId: ViewControllerID.changePasswordViewController.rawValue) as! ChangePasswordViewController
            self.navigationController?.pushViewController(changePasswordController, animated: true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return  indexPath.section == 1 ? 64 : ( UIDevice.current.userInterfaceIdiom == .pad ? 338 : 194 )
    }
}

