//
//  HMSuggestionTextField.swift
//  FrieghtSystem
//
//  Created by hmspl on 12/05/17.
//  Copyright © 2017 Hakunamatata solution (P) Ltd. All rights reserved.
//

import UIKit

@objc protocol HMSuggestionTextFieldDelegate {
    
    //TextField Delegates
    @objc optional func suggestionTextFieldDidBeginEditing(_ textField: UITextField)
    @objc optional func suggestionTextFieldDidEndEditing(_ textField: UITextField)
    @objc optional func suggestionTextFieldShouldClear(_ textField: UITextField)
    @objc optional func suggestionTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String)
    @objc optional func suggestionTextFieldShouldReturn(_ textField: UITextField) -> Bool
    
    //Constraint Delegates
    @objc optional func updateHeightConstraintsHMSuggestion(height: CGFloat, tag : Int)
    
    //TableView Delegate
    @objc optional func selectedSuggestion(object: AnyObject, tag: Int)
    @objc optional func btnActAddNewClicked()
    
}

@IBDesignable class HMSuggestionTextField: UIView {
    
    //MARK:- Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var viewSeparator: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnAddNew    : UIButton!
    
    
    @IBOutlet weak var heightConstraintForTableViewSuggestion: NSLayoutConstraint!
    
    enum RegexType {
        case alphaNumeric
        case none
    }
    
    let screenBounds = UIScreen.main.bounds
    
    var applyRegex: RegexType = .none
    
    var isCaseSensitive = false
    
    var delegate: HMSuggestionTextFieldDelegate?
    
    let sectionHeight: CGFloat = 40.0
    
    var suggestionList: [AnyObject] = []
    
    var filterSuggestionArray: [AnyObject] = []
    
    var showSectionHeader = false

    //MARK:- View life cycle
    
    override init(frame: CGRect) {
        
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        loadViewFromNib()
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(coder: aDecoder)
       
        // 3. Setup view from .xib file
        loadViewFromNib()
        
    }
    
    
    override func awakeFromNib() {
        
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.awakeFromNib()
        
    }
    
    func loadViewFromNib() {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "HMSuggestionTextField", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        
        registerTableViewCell()
    }
    
     //MARK:- Button Action -
    
    @IBAction func btnActAddNew(_ sender: UIButton) {
        
        self.delegate?.btnActAddNewClicked?()
    }
    
    
    
    //MARK:- Business logics
    
    func registerTableViewCell() {
    
        tableView.backgroundView?.borderColor = UIColor.black
        tableView.register(UINib(nibName: "HMSuggestionTableViewCell", bundle: nil), forCellReuseIdentifier: "HMSuggestionTableViewCellID")
    }
    
    func filterSuggerstionList(enteredString: String) {
        
        filterSuggestionArray.removeAll()
        
        if suggestionList.count > 0 || enteredString != ""
        {
            if isCaseSensitive
            {
                if suggestionList[0] is Customerlist
                {
                    filterSuggestionArray = (suggestionList as! [Customerlist]).filter() {
                        $0.name.hasPrefix(enteredString)
                    }
                }else if suggestionList[0] is EmployeeDetail
                {
                    filterSuggestionArray = (suggestionList as! [EmployeeDetail]).filter() {
                        $0.name.hasPrefix(enteredString)
                    }
                }
                else if suggestionList[0] is String
                {

                    for i in 0 ..< suggestionList.count
                    {
                        let suggestionItem = suggestionList[i] as! String
                        
                        if suggestionItem.hasPrefix(enteredString)
                        {
                            filterSuggestionArray.append(suggestionItem as AnyObject)
                        }
                    }
                }
            }
            else
            {
                if suggestionList[0] is Customerlist
                {
                    
                    filterSuggestionArray = (suggestionList as! [Customerlist]).filter() { $0.name.uppercased().contains(enteredString.uppercased()) }
                    
                }else if suggestionList[0] is EmployeeDetail
                {
                    
                    filterSuggestionArray = (suggestionList as! [EmployeeDetail]).filter() { $0.name.uppercased().contains(enteredString.uppercased()) }
                    
                } else if suggestionList[0] is Port {
                    
                    filterSuggestionArray = (suggestionList as! [Port]).filter() { $0.name.uppercased().hasPrefix(enteredString.uppercased()) }
                    
                } else if suggestionList[0] is String {

                    for i in 0 ..< suggestionList.count
                    {
                        let suggestionItem = suggestionList[i] as! String
                        
                        if suggestionItem.uppercased().hasPrefix(enteredString.uppercased())
                        {
                            filterSuggestionArray.append(suggestionItem as AnyObject)
                        }
                    }
                }
            }
        }

        var tableViewHeight: CGFloat = 0

        if filterSuggestionArray.count > 0
        {
            if showSectionHeader && filterSuggestionArray.count == 1
            {
                let height = CGFloat(filterSuggestionArray.count) * 35.0
                tableViewHeight = CGFloat(height + 40.0)
            }
            else
            {
                tableViewHeight = CGFloat(filterSuggestionArray.count * 35)
            }
            
            if tableViewHeight > 160.0
            {
                tableViewHeight = 160.0
            }
        }
        
        tableView.reloadData()

        if tableViewHeight > 0
        {
            tableView.setContentOffset(CGPoint.zero, animated: true)
        }
        
        animateSuggestionTableview(height: tableViewHeight)
    }
    
    func animateSuggestionTableview(height: CGFloat) {
        
//        var validatedHeight: CGFloat = 0.0
//        
//        if height > 0
//        {
//            validatedHeight = validateSuggestionListHeight(suggestionView: self, totalHeight: height)
//        }
        
    
        self.delegate?.updateHeightConstraintsHMSuggestion?(height: height, tag: self.textField.tag)
//
//        UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
//            self.heightConstraintForTableViewSuggestion.constant = height
//        }, completion: nil)
    }
    

    func validateSuperView(view: UIView) -> Bool {
        
        if view.bounds.height == screenBounds.height
        {
            return true
        }
        
        return false
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}


// MARK:- UITextFieldDelegate Methods

extension HMSuggestionTextField: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.delegate?.suggestionTextFieldDidBeginEditing?(textField)
        filterSuggerstionList(enteredString: "")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.suggestionTextFieldDidEndEditing?(textField)
        animateSuggestionTableview(height: -10)
    }
    
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.delegate?.suggestionTextFieldShouldClear?(textField)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let stringText = NSString(format: "%@", textField.text!)
        let checkString = stringText.replacingCharacters(in: range, with:string)
        let language = textField.textInputMode?.primaryLanguage

        if language == nil
        {
            return false
        }
        
        if string == ""
        {
            self.delegate?.suggestionTextField?(textField, shouldChangeCharactersIn: range, replacementString: string)
            
            filterSuggerstionList(enteredString: checkString as String)
            
            return true
        }
        
        switch applyRegex
        {
            
        case .alphaNumeric:
            
            if checkString.isAlphanumeric()
            {
                self.delegate?.suggestionTextField?(textField, shouldChangeCharactersIn: range, replacementString: string)
                
                filterSuggerstionList(enteredString: checkString as String)
                
                return true
            }

            return false
            
        default:
           
            self.delegate?.suggestionTextField?(textField, shouldChangeCharactersIn: range, replacementString: string)
            
            filterSuggerstionList(enteredString: checkString as String)
            
            return true

        }               
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder();
        animateSuggestionTableview(height: 0)
        return (self.delegate?.suggestionTextFieldShouldReturn?(textField))!
    }
}

// MARK:- UITableViewDelegate Methods

extension HMSuggestionTextField: UITableViewDelegate,UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filterSuggestionArray.count

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if showSectionHeader
        {
            let contentView = UIView(frame: CGRect(x : 0, y : 0, width : tableView.frame.size.width, height : sectionHeight))
            contentView.backgroundColor = UIColor.white
            
            let view = UIView(frame: CGRect(x : 0, y : 0, width : contentView.frame.size.width, height : sectionHeight))

            view.backgroundColor = UIColor.lightGray
            
            let label = UILabel(frame: CGRect(x : 9,y: 0, width:tableView.frame.size.width - 9, height : 39))
            label.font = UIFont(name: "Montserrat-Light", size: 11.0)
            label.text = "TOP PORT MATCHES"
            label.textColor = UIColor.black
            
            view.addSubview(label)
            
            let dummyBtn = UIButton(frame: CGRect(x : 0,y: 0, width:tableView.frame.size.width, height : 39))
            dummyBtn.backgroundColor = UIColor.clear
            view.addSubview(dummyBtn)
            
            contentView.addSubview(view)
            
            return contentView
        }
        else
        {
            return nil
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if showSectionHeader
        {
            return sectionHeight
        }
        else
        {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell = tableView.dequeueReusableCell(withIdentifier: "HMSuggestionTableViewCellID", for: indexPath) as! HMSuggestionTableViewCell
        
        // set the text from the data model

        let cellInfo = self.filterSuggestionArray[indexPath.row]

        if cellInfo is Customerlist
        {
            cell.configureSuggestionCell(name: (cellInfo as! Customerlist).name.capitalized)
        }else if cellInfo is EmployeeDetail
        {
            cell.configureSuggestionCell(name: (cellInfo as! EmployeeDetail).name.capitalized)
        }
        else if cellInfo is Port
        {
            cell.configureSuggestionCell(name: (cellInfo as! Port).name.capitalized)
        }
        else if cellInfo is String
        {
            cell.configureSuggestionCell(name: cellInfo as! String)
        }

        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        
        let cellInfo = self.filterSuggestionArray[indexPath.row]
        
        if cellInfo is Customerlist
        {
            let nameAndCode = "\((cellInfo as! Customerlist).name.uppercased())"
            
            textField.text = nameAndCode
        } else if cellInfo is Port
        {
            let nameAndCode = "\((cellInfo as! Port).name.uppercased())"
            
            textField.text = nameAndCode
        }
        else if cellInfo is String
        {
            textField.text = cellInfo as? String
            
        }else if cellInfo is EmployeeDetail
        {
            let nameAndCode = "\((cellInfo as! EmployeeDetail).name.uppercased())"
            
            textField.text = nameAndCode
        }
        
        self.delegate?.selectedSuggestion?(object: cellInfo, tag: self.tag)
        
        animateSuggestionTableview(height: 0)
    }
}





