//
//  NewPotentialBusinessViewController.swift
//  CallEntry
//
//  Created by Rajesh on 07/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

enum OrginAutoListCellHeight : CGFloat {
    
    case defaultHeight = 71
    case listSelectHeight = 230.0
}

protocol profileDataDelegate {
    func getProfile(data: [Profile])
}

class NewPotentialBusinessViewController: BaseViewController {
    
    // MARK:- View Static Variables -
    
     let titles = ["Segment","Type","Period","Origin","Destination","TOS","Commodity Group","No of Shipment","Volume","Business Status","Estimated Revenue","Closure Date"]
    
    var customerKey: String = ""
    var delegate : profileDataDelegate?
    var destination = ""
    var origin = ""
    // MARK:- View Dynamic Variables -
    struct RadioBox
    {
        var first: String
        var second: String
    }
    
    var objtitle: [RadioBox] = []
    var sectionNo: Int = 1
    var sectionIndex: [Int] = []
    var isEdit: Bool = false
    // MARK:- IBOutlets -
    
    @IBOutlet weak var tbleView: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnAddPotentialBusiness: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    
    // MARK:- Properties -
    var indexPath: IndexPath!
    var profile: [Profile] = [Profile()]
    // MARK:- Properties -
    var currentTextField: UITextField!
    var customerList : [Customerlist] = AppCacheManager.sharedInstance().customerList
    
    var selectedCustomerList: Port!
    var id: String!
    var cellHeightOrigin : CGFloat = OrginAutoListCellHeight.defaultHeight.rawValue
    var cellHeightDestination : CGFloat = OrginAutoListCellHeight.defaultHeight.rawValue
    var cellHeightTos: CGFloat          = OrginAutoListCellHeight.defaultHeight.rawValue
    var cellHeightCommodity: CGFloat    = OrginAutoListCellHeight.defaultHeight.rawValue
    var profileId : String = ""
    
    var isOrginFieldEditable : Bool = false
    
    var isSelectedTextFieldTag : Int = 0
    
    var custid: String = ""
    
    var model = PotentialBusinessModel()
    
    // MARK:- View Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewData()
        if (!isEdit){
            self.btnSave.isEnabled = false
            self.btnSave.alpha = 0.5
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- BUSINESS LOGICS -
    
    func getTheOrginPortValues() {
        
        
    }
    
    func getTheTosValues(tos: [Id]) -> [String] {
        var tosName: [String] = []
        for iterateTos in tos {
            tosName.append(iterateTos.name)
        }
        return tosName
    }
    
    func getTheCommodityValues(commodity: [Id]) -> [String] {
        var commodityName: [String] = []
        for iterateCommodity in commodity {
            commodityName.append(iterateCommodity.name)
        }
        return commodityName
    }
    
    func configureViewData() {
        tbleView.register(UINib(nibName: "NewCustomerEntryListTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tbleView.register(UINib(nibName: "TextFieldHMDatePickerTableViewCell", bundle: nil), forCellReuseIdentifier: "datePickerCell")
        lblTitle.text = self.isEdit ? "Edit Profile" : "Profile"
        btnAddPotentialBusiness.isHidden = self.isEdit ? true : false
        self.tbleView.estimatedRowHeight = 68
        self.tbleView.rowHeight = UITableViewAutomaticDimension
        // Initialization
        objtitle.append(RadioBox(first: "Import",second: "Export"))
        objtitle.append(RadioBox(first: "Monthly",second: "Weekly"))
        objtitle.append(RadioBox(first: "Current",second: "Potential"))
        self.sectionIndex.append(sectionNo)
    }
    
    func configureEditData()
    {
        
    }
    
    func isValidationSuccess() -> Bool {
        
        return true
    }
    
    func poppingToNewCustomer() {
        let NewCustomerviewController = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 2]
        if NewCustomerviewController is NewCustomerViewController {
            let NewCustomerController = NewCustomerviewController as! NewCustomerViewController
            NewCustomerController.dismiss()
            self.navigationController?.popViewController(animated: true)
    }
    }
    
    func generateUpdatePotentialRequest() -> UpdatePotentialBusinessRequest {
        let request = UpdatePotentialBusinessRequest()
        if let profile = self.profile.last {
        request.username = AppCacheManager.sharedInstance().userId
        request.user_token = AppCacheManager.sharedInstance().authToken
        request.cus_code = custid
        request.uid = profile.profileid
        request.segment = profile.segment.uppercased()
        request.type = profile.type
        request.origin  = AppCacheManager.sharedInstance().portData.port.filter { $0.name.uppercased() == profile.origin.uppercased() }.first?.code ?? profile.origin
        request.destination = AppCacheManager.sharedInstance().portData.port.filter { $0.name.uppercased() == profile.destination.uppercased() }.first?.code ?? profile.destination
        request.commodity = AppCacheManager.sharedInstance().masterData.commoditygroup.filter { $0.name.uppercased() == profile.commoditygroup.uppercased() }.first?.code ?? profile.commoditygroup
        request.tos = AppCacheManager.sharedInstance().masterData.tos.filter { $0.name.uppercased() == profile.tos.uppercased() }.first?.code ?? profile.tos
        request.busin = profile.currentpotential
        request.close_date = profile.closuredate
        request.est_revenue = profile.estimatedrevenue
        request.volume = profile.volume
        request.period = profile.period
        request.shpt = profile.noofshipments
        }
        return request
    }
    
    func generateNewPotentialRequest() -> NewPotentialBusinessRequest {
       
        let request = NewPotentialBusinessRequest()
         if let profile = self.profile.last {
        request.username = AppCacheManager.sharedInstance().userId
        request.user_token = AppCacheManager.sharedInstance().authToken
        request.cus_code = self.customerKey
        request.segment = profile.segment.uppercased()
        request.type = profile.type
        request.origin  = AppCacheManager.sharedInstance().portData.port.filter { $0.name.uppercased() == profile.origin.uppercased() }.first?.code ?? profile.origin
        request.destination = AppCacheManager.sharedInstance().portData.port.filter { $0.name.uppercased() == profile.destination.uppercased() }.first?.code ?? profile.destination
        request.commodity = AppCacheManager.sharedInstance().masterData.commoditygroup.filter { $0.name.uppercased() == profile.commoditygroup.uppercased() }.first?.code ?? profile.commoditygroup
        request.tos = AppCacheManager.sharedInstance().masterData.tos.filter { $0.name.uppercased() == profile.tos.uppercased() }.first?.code ?? profile.tos
        request.busin = profile.currentpotential
        request.close_date = profile.closuredate
        request.est_revenue = profile.estimatedrevenue
        request.volume = profile.volume
        request.period = profile.period
        request.shpt = profile.noofshipments
        }
        return request
      
    }
    
    //MARK:- BUTTON ACTIONS -
    
    @IBAction func backButtonAction(_ sender: Any)
    {
        if isEdit {
            self.navigationController?.popViewController(animated: true)
        }
        else {
           self.poppingToNewCustomer()
        }
         self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addActionButton(_ sender: Any)
    {
       self.tbleView.beginUpdates()
        sectionNo += 1
        self.sectionIndex.append(sectionNo)
        self.profile.append(Profile())
        self.tbleView.insertSections(IndexSet.init(integer: 1), with: .automatic)
       self.tbleView.endUpdates()
        self.tbleView.reloadSections(IndexSet.init(integer: 1), with: .automatic)
    }
    
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        
        self.showLoader()
        
        model.delegate = self
        
        if isEdit {
            model.updatePotentialBusiness(request: generateUpdatePotentialRequest())
        }
        else {
            model.newPotentialBusiness(request: generateNewPotentialRequest())
        }
    }

}
extension NewPotentialBusinessViewController: PotentialBusinessModelDelegate {

    func apiHitFailure(error: Error) {
        self.removeLoader()
        //Navigate to Selected Menu Page
        self.showAlertMessage(message: error.localizedDescription)
        
//        let NewCustomerviewController = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 2]
//        if NewCustomerviewController is NewCustomerViewController {
//            let NewCustomerController = NewCustomerviewController as! NewCustomerViewController
//
//            self.navigationController?.popViewController(animated: true)
//            NewCustomerController.dismiss()
//        }
       
    }
    
    func apiHitSuccess(isFrom: String,response : NewPotentialBusinessResponse) {

        let viewControllers = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 2]
        
            let addProfile = Profile()

            if let profile = self.profile.last {
                addProfile.segment = profile.segment.uppercased()
                addProfile.type = profile.type
                addProfile.profileid = response.profileid
                addProfile.origin  = origin
                addProfile.destination = destination
                addProfile.commoditygroup = AppCacheManager.sharedInstance().masterData.commoditygroup.filter { $0.name.uppercased() == profile.commoditygroup.uppercased() }.first?.code ?? profile.commoditygroup
                addProfile.tos = AppCacheManager.sharedInstance().masterData.tos.filter { $0.name.uppercased() == profile.tos.uppercased() }.first?.code ?? profile.tos
                addProfile.currentpotential = profile.currentpotential
                addProfile.closuredate = profile.closuredate
                addProfile.estimatedrevenue = profile.estimatedrevenue
                addProfile.volume = profile.volume
                addProfile.period = profile.period
                addProfile.noofshipments = profile.noofshipments
            }
            
            for customer in AppCacheManager.sharedInstance().customerList {
                if customer.custid == customerKey {
                    customer.profile.append(addProfile)
                }
            }

        if viewControllers is PotentialBusinessDetailViewController {
            let potentialBusinessDetailController = viewControllers as! PotentialBusinessDetailViewController
            self.navigationController?.popViewController(animated: true)
            potentialBusinessDetailController.reloadData()
        }
        self.poppingToNewCustomer()
        self.dismiss(animated: true, completion: nil)
        self.removeLoader()
    }

    func apiEditProfileHitSuccess(response : UpdatePotentialBusinessResponse) {
        
        let viewControllers = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 2]
        
        for customer in AppCacheManager.sharedInstance().customerList {
            if customer.custid == custid {
                for profile in customer.profile {
                    if profile.profileid == profileId {
                        if let editProfile = self.profile.last {
                            profile.profileid = editProfile.profileid
                            profile.segment = editProfile.segment.uppercased()
                            profile.type = editProfile.type
                            profile.origin  = origin
                            profile.destination = destination
                            profile.commoditygroup = AppCacheManager.sharedInstance().masterData.commoditygroup.filter { $0.name.uppercased() == profile.commoditygroup.uppercased() }.first?.code ?? profile.commoditygroup
                            profile.tos = AppCacheManager.sharedInstance().masterData.tos.filter { $0.name.uppercased() == profile.tos.uppercased() }.first?.code ?? profile.tos
                            profile.currentpotential = editProfile.currentpotential
                            profile.closuredate = editProfile.closuredate
                            profile.estimatedrevenue = editProfile.estimatedrevenue
                            profile.volume = editProfile.volume
                            profile.period = editProfile.period
                            profile.noofshipments = editProfile.noofshipments
                        }
                    }
                }
            }
        }
        
        if viewControllers is PotentialBusinessDetailViewController {
            let potentialBusinessDetailController = viewControllers as! PotentialBusinessDetailViewController
            self.navigationController?.popViewController(animated: true)
            potentialBusinessDetailController.reloadData()
        }
        self.poppingToNewCustomer()
        self.dismiss(animated: true, completion: nil)
        self.removeLoader()
        
    }
}
// MARK:- Delegate Methods -
//
//extension ViewControllerName: DelegateName {
//}

extension NewPotentialBusinessViewController: UITableViewDataSource,UITableViewDelegate {
    
    // TableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return self.profile.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
       
        if indexPath.row == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "segmentCell", for: indexPath) as! SegmentTableViewCell
            cell.delegate = self
            cell.lblTitle.text = titles[indexPath.row]
            cell.configureEditData(profile: profile[indexPath.section],index: indexPath)
            
            return cell
        } else if indexPath.row >= 3 && indexPath.row <= 6
        {
            if let cell = tableView.cellForRow(at: indexPath) as? OrginAutoListTableViewCell {
                
                cell.textFieldCustomer.becomeFirstResponder()
                
                cell.textFieldCustomer.textField.tag = indexPath.row
                
                cell.selectionStyle = .none
                
                return cell
            } else {
            
                let cell = tableView.dequeueReusableCell(withIdentifier: "OrginAutoListCellIdentifier", for: indexPath) as! OrginAutoListTableViewCell
                
                cell.textFieldCustomer.textField.tag = indexPath.row
                cell.textFieldCustomer.delegate = self
                cell.textFieldCustomer.textField.returnKeyType = .default
                cell.textFieldCustomer.applyRegex = .none
                
                cell.textFieldCustomer.btnAddNew.isHidden = true
                cell.textFieldCustomer.viewSeparator.isHidden = true
                cell.textFieldCustomer.textField.textColor = UIColor.black
                cell.textFieldCustomer.titleLabel.font = UIFont(name: "Roboto-Light", size: 13)
                cell.textFieldCustomer.textField.font  = UIFont(name: "Roboto-Regular", size: 13)
                cell.textFieldCustomer.titleLabel.text = titles[indexPath.row]
                
                switch indexPath.row
                {
                case 3:
                    cell.textFieldCustomer.suggestionList = AppCacheManager.sharedInstance().portData.port  as [AnyObject]
                    cell.textFieldCustomer.textField.text  = profile[indexPath.section].origin
                    origin = (cell.textFieldCustomer.textField.text?.uppercased())!
                case 4:
                    cell.textFieldCustomer.textField.text = profile[indexPath.section].destination
                    cell.textFieldCustomer.suggestionList = AppCacheManager.sharedInstance().portData.port  as [AnyObject]
                    destination = (cell.textFieldCustomer.textField.text?.uppercased())!
                    
                case 5:
                    cell.textFieldCustomer.textField.text = profile[indexPath.section].tos
                    cell.textFieldCustomer.suggestionList = self.getTheTosValues(tos: AppCacheManager.sharedInstance().masterData.tos) as [AnyObject]
                case 6:
                    cell.textFieldCustomer.textField.text = profile[indexPath.section].commoditygroup
                    cell.textFieldCustomer.suggestionList = self.getTheCommodityValues(commodity: AppCacheManager.sharedInstance().masterData.commoditygroup) as [AnyObject]
                default:
                    cell.textFieldCustomer.textField.text = ""
                }
                
                
                cell.selectionStyle = .none
                
                return cell
            }
        
        } else if indexPath.row < 5 || indexPath.row == 9
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Radiocell", for: indexPath) as! RadioButtonTableViewCell
            
            cell.delegate = self
            
            cell.lblTitle.text = titles[indexPath.row]
            cell.configureEditData(profile: profile[indexPath.section], index: indexPath)
            
            cell.btnFirst.setTitle(indexPath.row < 3 ? objtitle[indexPath.row - 1].first : objtitle[2].first, for: .normal)
            cell.btnSecond.setTitle(indexPath.row < 3 ? objtitle[indexPath.row - 1].second : objtitle[2].second, for: .normal)
    
            return cell
        }
            
        else if indexPath.row < 11
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NewCustomerEntryListTableViewCell
            
            cell.lblTop.text = titles[indexPath.row]
            cell.imgArrow.isHidden = true
            
            cell.configurePotentialBusinessData(indexpath: indexPath, profile: self.profile[indexPath.section])
            
            if indexPath.row == 7 || indexPath.row == 8 || indexPath.row == 10
            {
                cell.txtfldBottom.keyboardType = .numberPad
            }
            else
            {
                cell.txtfldBottom.keyboardType = .default
            }
            
            cell.txtfldBottom.tag = indexPath.row
            cell.txtfldBottom.delegate = self
            cell.textViewinput.isHidden = true
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "datePickerCell", for: indexPath) as! TextFieldHMDatePickerTableViewCell
            
            cell.lblTitle.text = titles[indexPath.row]
            cell.textFieldDatePicker.pickerDelegate = self
            cell.textFieldDatePicker.delegate = self
            cell.textFieldDatePicker.tag = indexPath.row
            
            cell.configureData(profile: self.profile[indexPath.section])

            return cell
        }
        
      
    }
    
   // Mark TableViewDelegate
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return "Profile \(self.sectionIndex[section])"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 42
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 14
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        //footer.backgroundColor = UIColor.init(red: 248/255, green: 248/255, blue: 248/255, alpha: 1)
        footer.backgroundColor = UIColor.clear
        return footer
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        if indexPath.row == 3 {
            return cellHeightOrigin
        }
        else if indexPath.row == 4 {
            return cellHeightDestination
        }
        else if indexPath.row == 5 {
            return cellHeightTos
        }
        else if indexPath.row == 6 {
            return cellHeightCommodity
        }
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 3 {
            return cellHeightOrigin
        }
       else if indexPath.row == 4 {
            return cellHeightDestination
        }
        else if indexPath.row == 5 {
            return cellHeightTos
        }
        else if indexPath.row == 6 {
            return cellHeightCommodity
        }
        
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor(red: 0.80, green: 0.07, blue: 0.21, alpha: 1)
        header.contentView.backgroundColor = UIColor.white
        let viewSeperator = UIView(frame: CGRect(x: 0, y: (header.bounds.height) - 1, width: header.bounds.width, height: 1))
        viewSeperator.backgroundColor = UIColor(red: 0.09, green: 0.09, blue: 0.09, alpha: 1)
        viewSeperator.alpha = 0.2
        header.addSubview(viewSeperator)
    }
    
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//
//        if indexPath.row == 3 {
//            if let cell = tableView.cellForRow(at: indexPath) as? OrginAutoListTableViewCell {
//                if cellHeight == 210.0 {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                        cell.textFieldCustomer.becomeFirstResponder()
//                        print("Yes")
//                    }
//                }
//            }
//        }
//    }
    
}

extension NewPotentialBusinessViewController: UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
         indexPath = getIndexPath(sender: textField,tbleView: self.tbleView)
        if textField.tag > 2
        {
            self.tbleView.contentInset.bottom = 300
            self.tbleView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         indexPath = getIndexPath(sender: textField, tbleView: self.tbleView)
        
        let char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            switch textField.tag
            {
            case 7:
                self.profile[indexPath.section].noofshipments.removeLast()
            case 8:
                self.profile[indexPath.section].volume.removeLast()
            case 10:
                self.profile[indexPath.section].estimatedrevenue.removeLast()
            default:
                break
            }
        }
        else {
        switch textField.tag
        {
        case 7:
            self.profile[indexPath.section].noofshipments = textField.text! + string
        case 8:
            self.profile[indexPath.section].volume = textField.text! + string
        case 10:
            self.profile[indexPath.section].estimatedrevenue = textField.text! + string
        default:
            break
        }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.tbleView.contentInset.bottom = 0
        textField.endEditing(true)
        return true
    }
}

extension NewPotentialBusinessViewController: segmentDelegate
{
    func segment(segment: String, _ sender: AnyObject)
    {
        self.profile[getIndexPath(sender: sender,tbleView: self.tbleView).section].segment = segment
    }
}

extension NewPotentialBusinessViewController: RadioButtonDelegate
{
   
    func Radio(sender: AnyObject, isFirstRadioButtonSelected: Bool)
    {
        indexPath = getIndexPath(sender: sender,tbleView: self.tbleView)
        if indexPath.row == 1
        {
            self.profile[indexPath.section].type = isFirstRadioButtonSelected == true ? "IMPORT" : "EXPORT"
        }
        else if indexPath.row == 2
        {
            self.profile[indexPath.section].period = isFirstRadioButtonSelected == true ? "M" : "W"
        }
        else
        {
             self.profile[indexPath.section].currentpotential = isFirstRadioButtonSelected == true ? "C" : "P"
        }
    }
    
}

extension NewPotentialBusinessViewController: HMPickerDelegate
{
    func pickerSelected(index : Int, selectedTag : Int,withData : AnyObject)
    {
        self.tbleView.contentInset.bottom = 0
        if let date = DateExtension.DateFormateString(datestring: withData as! String, CurrentFormat: "MM/dd/yyyy", ConvertFormat: "dd-MMM-YYYY") {
                self.profile[indexPath.section].closuredate = date
            if ( self.profile[indexPath.section].closuredate != ""){
                self.btnSave.isEnabled = true
                self.btnSave.alpha = 1.0
            }
            
        }
        self.tbleView.reloadData()
    }
}


// MARK: - HMSuggestionTextFieldDelegate Methods -
extension NewPotentialBusinessViewController : HMSuggestionTextFieldDelegate {
    
    func btnActAddNewClicked() {
        
        let newCustomerViewCtrl = getViewControllerInstance(storyboardName: StoryBoardID.customer.rawValue, storyboardId: ViewControllerID.newCustomerViewController.rawValue) as! NewCustomerViewController
        newCustomerViewCtrl.isEditingTextfield = true
        let navCtrl = UINavigationController(rootViewController: newCustomerViewCtrl)
        self.present(navCtrl, animated: true, completion: nil)
    }
    

    func suggestionTextFieldDidBeginEditing(_ textField: UITextField) {
        
        isOrginFieldEditable = true
        currentTextField = textField
        isSelectedTextFieldTag = textField.tag
    }
    
    
    func suggestionTextFieldDidEndEditing(_ textField: UITextField) {
     
        isOrginFieldEditable = false
        isSelectedTextFieldTag = textField.tag
        if (textField.text != "") {
            self.btnSave.isEnabled = true
            self.btnSave.alpha = 1.0
        }
    }
    
    func suggestionTextFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        textField.resignFirstResponder()
        
        return true
    }
    
    
    func suggestionTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) {
        
        let stringText = NSString(format: "%@", textField.text!)
        let checkString = stringText.replacingCharacters(in: range, with:string)
        
        selectedCustomerList = nil
        //stackViewCusDetail.isUserInteractionEnabled = false
        //stackViewCusDetail.alpha = 0.5
    }
    
    
    func updateHeightConstraintsHMSuggestion(height: CGFloat, tag : Int) {
        
        if isSelectedTextFieldTag == 3 {
            if cellHeightOrigin != OrginAutoListCellHeight.listSelectHeight.rawValue && isOrginFieldEditable {
                
                cellHeightOrigin = OrginAutoListCellHeight.listSelectHeight.rawValue
                tbleView.reloadRows(at: [IndexPath(row: isSelectedTextFieldTag, section: 0)], with: .none)
            }
        } else if isSelectedTextFieldTag == 4 {
            
            if cellHeightDestination != OrginAutoListCellHeight.listSelectHeight.rawValue && isOrginFieldEditable {
                
                cellHeightDestination = OrginAutoListCellHeight.listSelectHeight.rawValue
                tbleView.reloadRows(at: [IndexPath(row: isSelectedTextFieldTag, section: 0)], with: .none)
            }
        }
        else if isSelectedTextFieldTag == 5 {
            
            if cellHeightTos != OrginAutoListCellHeight.listSelectHeight.rawValue && isOrginFieldEditable {
                
                cellHeightTos = OrginAutoListCellHeight.listSelectHeight.rawValue
                tbleView.reloadRows(at: [IndexPath(row: isSelectedTextFieldTag, section: 0)], with: .none)
            }
        }
        else if isSelectedTextFieldTag == 6 {
            
            if cellHeightCommodity != OrginAutoListCellHeight.listSelectHeight.rawValue && isOrginFieldEditable {
                
                cellHeightCommodity = OrginAutoListCellHeight.listSelectHeight.rawValue
                tbleView.reloadRows(at: [IndexPath(row: isSelectedTextFieldTag, section: 0)], with: .none)
            }
        }
    }
    
    func selectedSuggestion(object: AnyObject, tag: Int) {
        
        if object is Port {
            selectedCustomerList = object as! Port
        }
        
        if object is String {
            self.id = object as! String
        }
        
        isOrginFieldEditable = false
        
        if isSelectedTextFieldTag == 3 {
            self.profile[0].origin = selectedCustomerList.name
            if cellHeightOrigin == OrginAutoListCellHeight.listSelectHeight.rawValue {
                
                cellHeightOrigin = OrginAutoListCellHeight.defaultHeight.rawValue
             //   tbleView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .none)
            }
        } else if isSelectedTextFieldTag == 4 {
              self.profile[0].destination = selectedCustomerList.name
            if cellHeightDestination == OrginAutoListCellHeight.listSelectHeight.rawValue {
                
                cellHeightDestination = OrginAutoListCellHeight.defaultHeight.rawValue
            //    tbleView.reloadRows(at: [IndexPath(row: 4, section: 0)], with: .none)
            }
        }
        else if isSelectedTextFieldTag == 5 {
            self.profile[0].tos = self.id
            if cellHeightTos == OrginAutoListCellHeight.listSelectHeight.rawValue {
                
                cellHeightTos = OrginAutoListCellHeight.defaultHeight.rawValue
           //     tbleView.reloadRows(at: [IndexPath(row: 5, section: 0)], with: .none)
            }
        }
        else if isSelectedTextFieldTag == 6 {
            self.profile[0].commoditygroup = self.id
            if cellHeightCommodity == OrginAutoListCellHeight.listSelectHeight.rawValue {
                
                cellHeightCommodity = OrginAutoListCellHeight.defaultHeight.rawValue
            //    tbleView.reloadRows(at: [IndexPath(row: 6, section: 0)], with: .none)
            }
        }
        self.tbleView.reloadData()
    }
}

