//
//  HMPlainSuggestionTextField.swift
//  FrieghtSystem
//
//  Created by Hmspl on 25/5/17.
//  Copyright © 2017 Hakunamatata solution (P) Ltd. All rights reserved.
//

import UIKit

@objc protocol HMPlainSuggestionTextFieldDelegate {
    
    //TextField Delegates
    @objc optional func plainSuggestionTextFieldDidBeginEditing(_ textField: UITextField)
    @objc optional func plainSuggestionTextFieldDidEndEditing(_ textField: UITextField)
    @objc optional func plainSuggestionTextFieldShouldClear(_ textField: UITextField)
    @objc optional func plainSuggestionTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    @objc optional func plainSuggestionTextFieldShouldReturn(_ textField: UITextField)
    
    //Constraint Delegates
    @objc optional func updateHeightConstraints(height: CGFloat)
    
    //TableView Delegate
    @objc optional func selectedSuggestion(object: AnyObject, tag: Int)
}

@IBDesignable class HMPlainSuggestionTextField: UIView {
    
    //MARK:- Properties

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tblViewSuggestion: UITableView!
    @IBOutlet weak var heightConstraintForTableViewSuggestion: NSLayoutConstraint!
    @IBOutlet weak var imgViewSearch: UIImageView!
    
    enum RegexType {
        case alphaNumeric
        case none
    }
    
    var applyRegex: RegexType = .none
    
    var isCaseSensitive = false
    
    var delegate: HMPlainSuggestionTextFieldDelegate?
    
    var suggestionList: [AnyObject] = []
    
    var filterSuggestionArray: [AnyObject] = []
    
    var showSectionHeader = false

    let sectionHeight: CGFloat = 40.0

    //MARK:- View life cycle
    
    override init(frame: CGRect) {
        
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        loadViewFromNib()
        self.configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        loadViewFromNib()
        self.configure()
        
    }
    
    
    override func awakeFromNib() {
        
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.awakeFromNib()
        
    }
    
    func loadViewFromNib() {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "HMPlainSuggestionTextField", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        
        registerTableViewCell()
    }
    
    
    //MARK:- Business logics
    
    func configure() {
        
        self.imgViewSearch.image = UIImage(named: "Search")
//        self.btnSearch.tintColor = UIConstants.HomeColorConstant.viewbackgroundColor

    }
    
    func registerTableViewCell() {
        
        tblViewSuggestion.register(UINib(nibName: "HMSuggestionTableViewCell", bundle: nil), forCellReuseIdentifier: "HMSuggestionTableViewCellID")
    }
    
    func filterSuggerstionList(enteredString: String) {
        
        filterSuggestionArray.removeAll()
        
        if suggestionList.count > 0
        {
            if isCaseSensitive
            {
//                if suggestionList[0] is PortmasterDTO
//                {
//
//                    filterSuggestionArray = (suggestionList as! [PortmasterDTO]).filter() { $0.name.hasPrefix(enteredString) }
//                }
//                else
                if suggestionList[0] is String
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
//                if suggestionList[0] is PortmasterDTO
//                {
//                    
//                    filterSuggestionArray = (suggestionList as! [PortmasterDTO]).filter() { $0.name.uppercased().hasPrefix(enteredString.uppercased()) }
//                }
//                else
                if suggestionList[0] is String
                {
                    
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
                tableViewHeight = CGFloat((filterSuggestionArray.count + 1) * 40)
            }
            else
            {
                tableViewHeight = CGFloat(filterSuggestionArray.count * 40)
            }
            
            if tableViewHeight > 160.0
            {
                tableViewHeight = 160.0
            }
        }
        
        tblViewSuggestion.reloadData()
        
        if tableViewHeight > 0
        {
            tblViewSuggestion.setContentOffset(CGPoint.zero, animated: true)
        }
        
        animateSuggestionTableview(height: tableViewHeight)
    }
    
    func animateSuggestionTableview(height: CGFloat) {
        
        self.delegate?.updateHeightConstraints?(height: height)
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
            self.heightConstraintForTableViewSuggestion.constant = height
        }, completion: { (finished: Bool) in
        })
    }

}


// MARK:- UITextFieldDelegate Methods

extension HMPlainSuggestionTextField: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.delegate?.plainSuggestionTextFieldDidBeginEditing?(textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.plainSuggestionTextFieldDidEndEditing?(textField)
        animateSuggestionTableview(height: 0)
        
    }
    
    //    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    //        self.delegate?.suggestionTextFieldShouldBeginEditing(textField)
    //        return true
    //    }
    //
    //    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    //        self.delegate?.suggestionTextFieldShouldEndEditing(textField)
    //        return true
    //    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.delegate?.plainSuggestionTextFieldShouldClear?(textField)
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
            self.delegate?.plainSuggestionTextField?(textField, shouldChangeCharactersIn: range, replacementString: string)
            
            filterSuggerstionList(enteredString: checkString as String)
            
            return true
        }
        
        switch applyRegex
        {
            
        case .alphaNumeric:
            
            if checkString.isAlphanumeric()
            {
                self.delegate?.plainSuggestionTextField?(textField, shouldChangeCharactersIn: range, replacementString: string)
                
                filterSuggerstionList(enteredString: checkString as String)
                
                return true
            }
            
            return false
            
        default:
            
            self.delegate?.plainSuggestionTextField?(textField, shouldChangeCharactersIn: range, replacementString: string)
            
            filterSuggerstionList(enteredString: checkString as String)
            
            return true
            
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder();
        self.delegate?.plainSuggestionTextFieldShouldReturn?(textField)
        animateSuggestionTableview(height: 0)
        return true
    }
}

// MARK:- UITableViewDelegate Methods

extension HMPlainSuggestionTextField: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filterSuggestionArray.count
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if showSectionHeader
        {
            
            let contentView = UIView(frame: CGRect(x : 0, y : 0, width : tableView.frame.size.width, height : sectionHeight))
            contentView.backgroundColor = UIColor.white
            
            let view = UIView(frame: CGRect(x : 0, y : 0, width : contentView.frame.size.width, height : sectionHeight))
            
            view.backgroundColor = UIColor.gray
            
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
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell = tableView.dequeueReusableCell(withIdentifier: "HMSuggestionTableViewCellID", for: indexPath) as! HMSuggestionTableViewCell
        
        // set the text from the data model
        
        let cellInfo = self.filterSuggestionArray[indexPath.row]
        
//        if cellInfo is PortmasterDTO
//        {
//            cell.configureSuggestionCell(name: (cellInfo as! PortmasterDTO).name.capitalized)
//        }
//        else
        if cellInfo is String
        {
            cell.configureSuggestionCell(name: cellInfo as! String)
        }
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        
        let cellInfo = self.filterSuggestionArray[indexPath.row]
        
//        if cellInfo is PortmasterDTO
//        {
//            let nameAndCode = "\((cellInfo as! PortmasterDTO).name.uppercased()) (\((cellInfo as! PortmasterDTO).code.uppercased()))"
//
//            textField.text = nameAndCode
//        }
//        else
        if cellInfo is String
        {
            textField.text = cellInfo as? String
        }
        
        self.delegate?.selectedSuggestion?(object: cellInfo, tag: self.tag)
        
        animateSuggestionTableview(height: 0)
    }
}
