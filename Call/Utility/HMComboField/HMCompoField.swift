//
//  HMCompoField.swift
//  HMCustomComponents
//
//  Created by HMSPL on 30/05/15.
//  Copyright (c) 2015 HMSPL. All rights reserved.
//

import UIKit

enum kComboPickerType{
    case ComboCustomPicker
    case ComboDate
    case ComboDateWithTime
    case ComboTime
    case ComboMultiComponentPicker
}


@objc protocol HMPickerDelegate
{
    func pickerSelected(index : Int, withData : AnyObject)
}

class HMCompoField : UITextField {

    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var headerView: UIView!
    
    private var _textColor: UIColor?

    private var _tintColor: UIColor?

    @IBOutlet weak  var picker : UIPickerView?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    var pickerDelegate : HMPickerDelegate?
    var pickerType : kComboPickerType = .ComboCustomPicker
    
    var minDate : String = ""
    var maxDate : String = ""
    var setDate : String = ""
    
    var dateformat : String = "MM/dd/yyyy"
    var multiLineSupport = false
    var maxLength = 40
    
    var multilinelabel : UILabel!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    
    // this is the compo details. It can be any object of a dictionary. or custom objects. If the component is multicomponent picker, then we need to provide an array of array. first level array is number of component and second level array is data
    var list : NSArray = NSArray()
    
    var key : String?
    
    var selectedIndex = -1; //default selected index is the first object.
    
    //skip array will remove the items from the list. so that array will not show in the picker.
    var skipArray : NSArray = NSArray()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder : aDecoder)
        self.delegate = self
    }
    
    
    /*
    override func awakeFromNib() {
        super.awakeFromNib()
                
        self.tintColor = HMThemeManager.sharedInstance.selectedSubHeaderColor
        self.textColor = HMThemeManager.sharedInstance.selectedSubHeaderColor

    }
    
    
    override var textColor: UIColor? {
        
        set
        {
            _textColor = newValue
            super.textColor = _textColor
            
        }
        get
        {
            return _textColor
        }
    }
    
    
    override var tintColor: UIColor? {
        
        set
        {
            _tintColor = newValue
            super.tintColor = _tintColor
        }
        get
        {
            return _tintColor
        }
    }
    
    */

    
    func loadView(){
        
        //get picker view
         let nibName:String = "HMCompoTextField"
        let bundle =  Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        
        let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        self.inputView = view
        self.inputView?.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        
        switch(self.pickerType)
        {
        case .ComboCustomPicker:
            self.datePicker.isHidden = true
            self.picker?.isHidden = false
            self.picker?.sizeToFit()
            
            if selectedIndex > -1 && list.count > selectedIndex
            {
                self.picker?.selectRow(selectedIndex, inComponent: 0, animated: true)
                
            }
            
        case .ComboDate:
            self.datePicker.isHidden = false
            self.picker?.isHidden = true
            self.datePicker.datePickerMode = .date

            let dateFormatter = DateFormatter()
            let enUSPosixLocale = Locale(identifier: "en_US_POSIX")
            dateFormatter.locale = enUSPosixLocale
            dateFormatter.dateFormat = dateformat
            
            if setDate != ""
            {
                self.datePicker.date = dateFormatter.date(from: setDate as String) ?? Date()
            }
            
            if minDate != ""
            {
                self.datePicker.minimumDate = dateFormatter.date(from: minDate as String)
            }
            
            if maxDate != ""
            {
                self.datePicker.maximumDate = dateFormatter.date(from: maxDate as String)
            }
            
        case .ComboDateWithTime:
            self.datePicker.isHidden = false
            self.picker?.isHidden = true
            self.datePicker.datePickerMode = .dateAndTime
            reloadTime()

        case .ComboTime:
            self.datePicker.isHidden = false
            self.picker?.isHidden = true
            self.datePicker.datePickerMode = .time
            
        case .ComboMultiComponentPicker:
            self.datePicker.isHidden = true
            self.picker?.isHidden = false

        }
        
        
        if multiLineSupport
        {
            multilinelabel = UILabel(frame: CGRect(x: 0, y: 0, width: 280, height: 45))
            //multilinelabel.frame.size.width -= 20
            multilinelabel.numberOfLines = 0
            multilinelabel.backgroundColor = UIColor.red
            multilinelabel.backgroundColor = UIColor.clear
            multilinelabel.font = UIFont.systemFont(ofSize: 13)
       //     multilinelabel.sizeToFit()
            self.addSubview(multilinelabel)
            self.clipsToBounds = false
            
//            multilinelabel.addConstraint(NSLayoutConstraint(item: self,
//                attribute: NSLayoutAttribute.Trailing,
//                relatedBy: NSLayoutRelation.Equal,
//                toItem: multilinelabel,
//                attribute: NSLayoutAttribute.Trailing,
//                multiplier: 1,
//                constant: 0.0))
//            
//            multilinelabel.addConstraint(NSLayoutConstraint(item: self,
//                attribute: NSLayoutAttribute.Bottom,
//                relatedBy: NSLayoutRelation.Equal,
//                toItem: multilinelabel,
//                attribute: NSLayoutAttribute.Bottom,
//                multiplier: 1,
//                constant: 0.0))
//
//            
//            
//            multilinelabel.addConstraint(NSLayoutConstraint(item: self,
//                attribute: NSLayoutAttribute.Leading,
//                relatedBy: NSLayoutRelation.Equal,
//                toItem: multilinelabel,
//                attribute: NSLayoutAttribute.Leading,
//                multiplier: 1,
//                constant: 0.0))
//
//            
//            
//            multilinelabel.addConstraint(NSLayoutConstraint(item: self,
//                attribute: NSLayoutAttribute.Top,
//                relatedBy: NSLayoutRelation.Equal,
//                toItem: multilinelabel,
//                attribute: NSLayoutAttribute.Top,
//                multiplier: 1,
//                constant: 0.0))
//            
            
        }
        
    }
    
    func getSelectedItem() -> AnyObject? {
        
        if list.count == 0 || selectedIndex == -1 {
            return "Select" as AnyObject
        }
        
        return list[selectedIndex] as AnyObject
    }

    func  setSelectedItem(keyValue : String, value : String){
       
        let predicate : NSPredicate? = NSPredicate(format: "%K = %@",keyValue,value)
        
        let filterdobject = self.list.filtered(using: predicate!)
        if filterdobject.count > 0 {
            let object: AnyObject = filterdobject[0] as AnyObject
            
            if (multiLineSupport)
            {
               multilinelabel.text = object.value(forKey: key! as String) as? String
            }
            else
            {
                self.text = object.value(forKey: key! as String) as? String
            }
            
            self.selectedIndex = self.list.index(of: object)
        }

    }
    
    func setSelectedItem(keyValue : String) {
        let predicate : NSPredicate? = NSPredicate(format: "%K = %@",key!,keyValue)
        
        let filterdobject = self.list.filtered(using: predicate!)
        if filterdobject.count > 0 {
            let object: AnyObject = filterdobject[0] as AnyObject
            if (multiLineSupport){
                multilinelabel.text = object.value(forKey: key! as String) as? String
            }else{
                self.text = object.value(forKey: key! as String) as? String
            }
            self.selectedIndex = self.list.index(of: object)
        }
    }
    
    
    func setSelectedItemWithAdd(keyValue : String, selectItem : AnyObject){
        let predicate : NSPredicate? = NSPredicate(format: "%K = %@",key!,keyValue)
        
        let filterdobject = self.list.filtered(using: predicate!)
        if filterdobject.count > 0
        {
            let object: AnyObject = filterdobject[0] as AnyObject
           
            if (multiLineSupport)
            {
                multilinelabel.text = object.value(forKey: key! as String) as? String
            }
            else
            {
                self.text = object.value(forKey: key! as String) as? String
            }
            
            self.selectedIndex = self.list.index(of: object)
        }
        else
        {
            let tempListArray = NSMutableArray(array: list)
            tempListArray.insert(selectItem, at: 0)
            self.list = tempListArray as NSArray
            self.selectedIndex = 0
        }

    }
    
  override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
//        if action == "paste:" {
//            return false
//        }
//        return true
        return false
    }

    
    @IBAction func doneAction(sender : UIButton?){
    
        if (self.pickerType == .ComboDate)
        {

            self.text = CodeSnippets.getStringFromLocaleDate(date: self.datePicker.date, dateFormatString:  dateformat) ?? ""
//
            
//            if dateKey == "quoDt"
//            {
//                let dateWithTime = CodeSnippets.getStringFromLocaleNSDate(self.datePicker.date, dateFormatString: "hh:mm a MMM dd, yyyy") as? String ?? ""
//                pickerDelegate?.pickerSelected(0, withData: dateWithTime as String)
//            }
//            else
//            {
                pickerDelegate?.pickerSelected(index: 0, withData: self.text! as String as AnyObject)
//            }
            
            self.resignFirstResponder()
            return
            
        }
        else if (self.pickerType == .ComboDateWithTime)
        {
            self.text = CodeSnippets.getStringFromLocaleDate(date: self.datePicker.date, dateFormatString: dateformat) ?? ""
        }
        else if( self.pickerType == .ComboTime)
        {
            self.text = CodeSnippets.getStringFromLocaleDate(date: self.datePicker.date, dateFormatString: "hh:mm a") ?? ""
        }
        else
        {
            // normal
            
            if selectedIndex == -1
            {
                selectedIndex = 0
            }
            
            //if key is enabled we get dictionary from the selected value
            if key != nil
            {
                
                if self.pickerType == .ComboMultiComponentPicker
                {
                    self.text = fillMultipleComponentText(value: self.key!)
                    self.resignFirstResponder()
                    return
                }
                else if multiLineSupport
                {
                    // once selected we have to change the textField to lable.
                    multilinelabel.text = (list[selectedIndex] as AnyObject).value(forKey: self.key!) as? String
                    self.text = ""
                    pickerDelegate?.pickerSelected(index: selectedIndex, withData: (list[selectedIndex] as AnyObject).value(forKey: self.key!) as! NSObject)
                    self.resignFirstResponder()
                    return

                }
                
                self.text = (list[selectedIndex] as AnyObject).value(forKey: self.key!) as? String
                pickerDelegate?.pickerSelected(index: selectedIndex, withData: (list[selectedIndex] as AnyObject).value(forKey: self.key!) as! NSObject)
                
                self.resignFirstResponder()
                return
            }
            
            //if key is enabled we get dictionary from the selected value
            if self.pickerType == .ComboMultiComponentPicker {
                self.text = fillMultipleComponentText(value: nil)
                
                self.resignFirstResponder()
                return
            }
            
            self.text = list[selectedIndex] as? String
            pickerDelegate?.pickerSelected(index: selectedIndex, withData: list[selectedIndex] as AnyObject)

        }
    
    
    self.resignFirstResponder()
    
    }
    
    
     func setMultilineText(text : String){
        
            multilinelabel.text = text;
        self.text = ""
        
    }
    
    func fillMultipleComponentText(value : String?) -> String {
        let textString = ""
//        for var i = 0; i < list.count; i++ {
//            if let tempValue = value as String? {
//                textString += list[i][self.picker!.selectedRowInComponent(i)].valueForKey(tempValue) as! String
//                
//            }else{
//                textString += list[i][self.picker!.selectedRowInComponent(i)] as! String
//                
//            }
//            textString += " "
//        }
        return textString
    }
    
   @IBAction func canceAction(){
        self.resignFirstResponder()
    }
    
    
    func reloadData() {
        
        selectedIndex = -1
        
        // remove skip array from list. 
        let tempArray = NSMutableArray(array: list)
        for arryObj in skipArray {
            
            let predicate : NSPredicate? = NSPredicate(format: "%K = %@",key!,(arryObj as AnyObject).value(forKey: key! as String) as! String)
            
            var filterdobject = self.list.filtered(using: predicate!)
            if filterdobject.count > 0 {
                
                tempArray.remove(filterdobject[0])
//                var object: AnyObject = filterdobject[0]
//                self.text = object.valueForKey(key! as String) as! String
//                self.selectedIndex = self.list.indexOfObject(object)
            }
            
        }
        
        list = tempArray as NSArray
       // picker?.reloadAllComponents()
        
    }
    
    func resetDate() {
        
        let dateFormatter = DateFormatter()
        let enUSPosixLocale = Locale(identifier: "en_US_POSIX")
        dateFormatter.locale = enUSPosixLocale
        dateFormatter.dateFormat = dateformat
        
        if setDate != ""
        {
            self.datePicker.date = dateFormatter.date(from: setDate as String) ?? Date()
        }
        
        if minDate != ""
        {
            self.datePicker.minimumDate = dateFormatter.date(from: minDate as String)
        }
        
        if maxDate != ""
        {
            self.datePicker.maximumDate = dateFormatter.date(from: maxDate as String)
        }
        
        self.text = setDate as String
    }
    
    //MARK: delegates * data source
    func reloadTime() {
        
        let dateFormatter = DateFormatter()
        let enUSPosixLocale = Locale(identifier: "en_US_POSIX")
        dateFormatter.locale = enUSPosixLocale
        dateFormatter.dateFormat = dateformat
        
        if setDate != ""
        {
            self.datePicker.date = dateFormatter.date(from: setDate as String)!
        }
        
        if minDate != ""
        {
            self.datePicker.minimumDate = dateFormatter.date(from: minDate as String)
        }
        
        if maxDate != ""
        {
            self.datePicker.maximumDate = dateFormatter.date(from: maxDate as String)
        }
    }
    

    @IBAction func datePickerValueChangedAction(sender: AnyObject) {
        
       
    }
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        return CGRect.zero
    }
}

//MARK: UIPickerViewDelegate Methods

extension HMCompoField: UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        if self.pickerType == .ComboMultiComponentPicker {
            return list.count
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if self.pickerType == .ComboMultiComponentPicker
        {
            return (list[component] as AnyObject).count
        }
        
        return list.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if key != nil
        {
            
            if self.pickerType == .ComboMultiComponentPicker
            {
                return ((list[component] as! NSArray)[row] as AnyObject).value(forKey: self.key!) as? String
            }
            
            return (list[row] as AnyObject).value(forKey: self.key!) as? String
        }
        
        if self.pickerType == .ComboMultiComponentPicker {
            // return list[component][row] as? String
        }
        return list[row] as? String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedIndex = row
    }
    

}

//MARK: UITextFieldDelegate Methods

extension HMCompoField: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        self.borderWidth = 0
        if (picker?.isHidden == false && selectedIndex != -1)
        {
            picker?.selectRow(selectedIndex, inComponent: 0, animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            return true
        }
        
        if textField.text!.characters.count + string.characters.count > self.maxLength {
            return false
        }
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
        return true
    }
}





