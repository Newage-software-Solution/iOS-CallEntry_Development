//
//  SalesmeetDetailViewController.swift
//  CallEntry
//
//  Created by HMSPL on 26/02/19.
//  Copyright © 2019 Gowtham. All rights reserved.
//

import UIKit



class SalesmeetDetailViewController: BaseViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var textViewDetail: UITextView!
    
    var navTitle: String = ""
    
    var detail: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        // Do any additional setup after loading the view.
    }
    
    func loadData() {
        lblTitle.text = navTitle
        
        textViewDetail.text = detail == "" ? "No data found" : detail
        textViewDetail.scrollRangeToVisible(NSRange(location:0, length:0))
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
