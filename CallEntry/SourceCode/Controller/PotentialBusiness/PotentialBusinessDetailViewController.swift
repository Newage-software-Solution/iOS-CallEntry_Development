//
//  PotentialBusinessDetailViewController.swift
//  CallEntry
//
//  Created by Rajesh on 07/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

class PotentialBusinessDetailViewController: BaseViewController {
    
    // MARK:- View Static Variables -
    
    // MARK:- IBOutlets -
    
    @IBOutlet weak var tbleView: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    // MARK:- Properties -
    
    var profiles: [Profile] = []
    var custid: String = ""
    var isFrom : String = ""
    // MARK:- View Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //custid = SharedPersistance().getCustomerId()
        configureViewData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(AppCacheManager.sharedInstance().customerList)
        if (isFrom == "") {
            for customer in AppCacheManager.sharedInstance().customerList {
                if customer.custid == custid {
                    profiles = customer.profile
                }
            }
            reloadData()
        }
    
    }
    //MARK:- BUSINESS LOGICS -
    
    func configureViewData() {
        tbleView.tableFooterView = UIView()
    }
    
    func reloadData() {
        self.tbleView.reloadData()
    }
    
    //MARK:- BUTTON ACTIONS -
    
    @IBAction func addPotentialBusinessButtonAction(_ sender: UIButton) {
        isFrom = ""
        let newpotentialBusinessController = self.getViewControllerInstance(storyboardName: StoryBoardID.potentialBusiness.rawValue, storyboardId: ViewControllerID.newPotentialBusinessViewController.rawValue) as! NewPotentialBusinessViewController
        newpotentialBusinessController.sectionNo = self.profiles.count + 1
        newpotentialBusinessController.customerKey = self.custid
        
        self.present(newpotentialBusinessController, animated: true, completion: nil)
        
    }
    
    
    
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
extension PotentialBusinessDetailViewController: UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return profiles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProfileTableViewCell
        cell.delegate = self
        cell.btnEditPotentialBusiness.tag = indexPath.section
        cell.configureCellContent(profile: profiles[indexPath.section],section: indexPath.section + 1)
        cell.configureTextFieldEditing(isEdit: false)
        cell.contentView.layer.cornerRadius = 9
        cell.contentView.layer.borderWidth = 1
        cell.contentView.layer.borderColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1).cgColor
        cell.contentView.clipsToBounds = true
        cell.contentView.layer.masksToBounds = true
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        let footer = UIView()
        footer.backgroundColor = UIColor.init(red: 248/255, green: 248/255, blue: 248/255, alpha: 1)
        return footer
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 336
    }
    
}

extension PotentialBusinessDetailViewController: EditButtonDelegate
{
    func editButtonAction(button: UIButton)
    {
        let editPotentialBusinessController = self.getViewControllerInstance(storyboardName: StoryBoardID.potentialBusiness.rawValue, storyboardId: ViewControllerID.newPotentialBusinessViewController.rawValue) as! NewPotentialBusinessViewController
        if let closedate = DateExtension.DateFormateString(datestring: self.profiles[button.tag].closuredate, CurrentFormat: "dd-MMM-yy", ConvertFormat: "dd-MMM-yyyy") {
        self.profiles[button.tag].closuredate = closedate
        }
        editPotentialBusinessController.profile[0] = self.profiles[button.tag]
        editPotentialBusinessController.isEdit = true
        editPotentialBusinessController.sectionNo = button.tag + 1
        editPotentialBusinessController.custid = self.custid
        self.navigationController?.pushViewController(editPotentialBusinessController, animated: true)
    }
}

