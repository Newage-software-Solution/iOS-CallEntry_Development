//
//  ListViewController.swift
//  CallEntry
//
//  Created by HMSPL on 26/02/19.
//  Copyright © 2019 Gowtham. All rights reserved.
//

import UIKit

class ListViewController: BaseViewController {

    @IBOutlet weak var tableViewList: UITableView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    
    var list: [String] = []
    var textDetailList: [String] = []
    var navTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
        // Do any additional setup after loading the view.
    }
    

    func loadData() {
        
        lblTitle.text = "\(navTitle)"
        tableViewList.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "listCell")
        tableViewList.allowsSelection = true
        tableViewList.tableFooterView = UIView()
        tableViewList.estimatedRowHeight = 50
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        sideMenuController?.isLeftViewSwipeGestureDisabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        sideMenuController?.isLeftViewSwipeGestureEnabled = true
    }
    
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func navigateToSalesMeetDetail(navTitle: String,detailText: String) {
        
        let salesDetailController = self.getViewControllerInstance(storyboardName: StoryBoardID.salesmeet.rawValue, storyboardId: ViewControllerID.SalesmeetDetailViewController.rawValue) as! SalesmeetDetailViewController
        
        salesDetailController.detail = detailText
        salesDetailController.navTitle = navTitle
        
        self.navigationController?.pushViewController(salesDetailController, animated: true)
        
    }

}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! ListTableViewCell
        cell.configureData(title: list[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigateToSalesMeetDetail(navTitle: list[indexPath.row], detailText: textDetailList[indexPath.row])
    }
}
