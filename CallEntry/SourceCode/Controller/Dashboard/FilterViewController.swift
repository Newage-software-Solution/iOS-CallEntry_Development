//
//  FilterViewController.swift
//  CallEntry
//
//  Created by Rajesh on 07/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

protocol SelectedSalesmanDelegate {
    func selectedSalesman(empcode: Salesmanlist)
}

class FilterViewController: BaseViewController {
    
    // MARK:- View Static Variables -
    
    let alphabets = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","#"]
    
    // MARK:- View Dynamic Variables
    
    var isSearch = false
    var filtered: [String] = []
    var model = DashboardModel()
    var salesManList: [String] = []
    var totalSection: Int = 0
    var sectionHeaderTitle: [String] = []
    var salesManNames: [[String]] = []
    var delegate: SelectedSalesmanDelegate?
    // MARK:- IBOutlets -
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tbleView: UITableView!
    // MARK:- Properties -
    
    // MARK:- View Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.salesmanListDelegate = self
        configureViewData()
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- BUSINESS LOGICS -
    
    func configureViewData() {
        self.showLoader()
        tbleView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        model.getSalesManList(request: getSalesManListRequest())
        self.tbleView.tableFooterView = UIView()
       
    }
    
    func getSalesManListRequest() -> GetSalesManListRequest
    {
        let request = GetSalesManListRequest()
        request.userid = AppCacheManager.sharedInstance().userId
        request.usertoken = AppCacheManager.sharedInstance().authToken
        return request
    }
    
    // Calculating the total section for tableView
    func calculatingList()
    {
        var temp: [String] = []
        for i in 0 ..< alphabets.count
        {
             temp = salesManList.filter( { $0.uppercased().first == alphabets[i].first } )
            if temp.count > 0
            {
                totalSection += 1
                 self.sectionHeaderTitle.append(alphabets[i])
                self.salesManNames.append(temp)
            }
            temp = []
            
        }
        
    }
    
    //MARK:- BUTTON ACTIONS -
    
    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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

extension FilterViewController: DashboardSalesManListDelegate {
    func apiHitSuccess()
    {
        self.salesManList = model.salesManList.map( { $0.name }).sorted()
        calculatingList()
        self.removeLoader()
        self.tbleView.reloadData()
    }
    
    func apiHitFailure()
    {
        self.removeLoader()
    }
}

extension FilterViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return isSearch ? 1 : totalSection
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]?
    {
        return alphabets
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  isSearch ? filtered.count : salesManNames[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if isSearch
        {
            cell.textLabel?.text = filtered[indexPath.row]
        }
        else
        {
            cell.textLabel?.text = salesManNames[indexPath.section][indexPath.row]
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return isSearch ? 0 : 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let emp = model.salesManList.filter { $0.name == (isSearch ? filtered[indexPath.row] : self.salesManNames[indexPath.section][indexPath.row]) }.first
        self.delegate?.selectedSalesman(empcode: (emp)!)
        //self.navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: {
        })
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.text =  sectionHeaderTitle[section]
        header.textLabel?.textColor = UIColor(hex: "007aff")
        header.textLabel?.font = UIFont(name: "Roboto Medium", size: 15)
    }
    
}

extension FilterViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let stringText = NSString(format: "%@", textField.text!)
        let checkString = stringText.replacingCharacters(in: range, with:string)
        
        filtered = salesManList.filter {  $0.range(of: checkString, options: .caseInsensitive) != nil }
        
        isSearch = (filtered.count == 0 && string == "") ? false : true
        
        self.tbleView.reloadData()
        
        return true
    }
}

