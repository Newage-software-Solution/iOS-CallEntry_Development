//
//  SalesmeetViewController.swift
//  CallEntry
//
//  Created by HMSPL on 26/02/19.
//  Copyright © 2019 Gowtham. All rights reserved.
//

import UIKit

enum salesmeetType: String {
    case travel = "Travel"
    case stay_Venue = "Stay & Venue"
    case dressCode = "Dress Code"
    case agenda = "Agenda"
    case eventInfo = " Event Information"
    case needAssistance = "Need Assistance"
}

class SalesmeetItemsViewController: BaseViewController {
    
    var salesmeetListType: [salesmeetType] = [.travel, .stay_Venue, .dressCode, .agenda, .eventInfo, .needAssistance]
    
    var imageArray: [String] = ["travel","stay_venue","dresscode","agenda","orgInfo","need_assist"]
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        // Do any additional setup after loading the view.
    }
    
    func loadData() {
        
        collectionView.register(UINib(nibName: "SalesMeetItemsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "salesmeetItemsCell")
        
       
    }
    
    func navigateToListController(list: [String],selectedType: salesmeetType,detailTextList: [String]) {
        
        let listController = self.getViewControllerInstance(storyboardName: StoryBoardID.salesmeet.rawValue, storyboardId: ViewControllerID.listViewController.rawValue) as! ListViewController
        listController.navTitle = selectedType.rawValue
        listController.list = list
        listController.textDetailList = detailTextList
        self.navigationController?.pushViewController(listController, animated: true)
        
    }
    

}

extension SalesmeetItemsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return salesmeetListType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "salesmeetItemsCell", for: indexPath) as! SalesMeetItemsCollectionViewCell
        
        cell.configureData(title: salesmeetListType[indexPath.item].rawValue,name: imageArray[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var list: [String] = []
        var detailTextList: [String] = []
        
        switch salesmeetListType[indexPath.item] {
        case .travel:
            list = ["Arrival","Departure"]
            detailTextList = [Travel.arrival,Travel.departure]
        case .stay_Venue:
            list = ["Venue Details","Event Details","Map to venue","Room Details","Hotel Amenities"]
             detailTextList = [Stay_Venue.venueDetails,Stay_Venue.eventDetails,"",Stay_Venue.roomDetails,Stay_Venue.hotelAmenties]
        case .dressCode:
            list = ["Day 1","Day 2"]
            detailTextList = [DressCode.day1,DressCode.day2]
        case .agenda:
            list = ["Day 1","Day 2"]
            detailTextList = [Agenda.day1,Agenda.day2]
        case .eventInfo:
            list = ["About","India Sales Meet 2018","India Sales Meet 2017"]
            detailTextList = [OrganisationInformation.about,OrganisationInformation.indiaSalesmeet2018,OrganisationInformation.indiaSalesmeet2017]
        case .needAssistance:
            list = ["Travel co-Ordinator Contact","Hotel co-Ordinator Contact","Event co-Ordinator Contact","Email Help Desk"]
            detailTextList = [NeedAssistance.travelCoordinatorContact,NeedAssistance.hotelCoordinatorContact,NeedAssistance.eventCoordinatorContact,NeedAssistance.emailHelpdesk]
        }
        
        navigateToListController(list: list, selectedType: salesmeetListType[indexPath.item], detailTextList: detailTextList)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.width / 3 - 5, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
