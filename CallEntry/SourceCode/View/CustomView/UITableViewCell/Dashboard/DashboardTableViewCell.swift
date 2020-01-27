//
//  DashboardTableViewCell.swift
//  CallEntry
//
//  Created by HMSPL on 09/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

protocol DashboardTableViewCellDelegate {
    func shipmentHistoryAction(callList: Calllist)
}

protocol SummaryPageDelegate
{
    func tickGreenAction(callList: Calllist)
}

protocol showAllButtonActionDelegate {
    func showAllButtonAction(sender: AnyObject, btnSection : Int)
}

protocol CallMailDelegate {
    func CallMail(calllist: Calllist)
}

class DashboardTableViewCell: BaseTableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnShowall: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var lblCallsType: UILabel!
    
    var delegate: DashboardTableViewCellDelegate?
    
    var summaryDelegate: SummaryPageDelegate?
    
    var showallDelegate: showAllButtonActionDelegate?
    
    var delegateCallMail: CallMailDelegate!
    
    var dashboardViewController: UIViewController!
    
    var segmentType: DashboardListSegment = .none
    
    var calls: [Calllist] = []
    var overDueCalls: [OverDueCallList] = []
    
    //MARK:- UITableViewCell LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(UINib.init(nibName: "CustomerCallsboxCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomerCell")
        
//        let collectionViewFlowLayout = UICollectionViewFlowLayout()
//        //collectionViewFlowLayout.minimumLineSpacing = 20
//        //collectionViewFlowLayout.minimumInteritemSpacing = 0
//        collectionViewFlowLayout.scrollDirection = .horizontal
//        collectionView.collectionViewLayout = collectionViewFlowLayout as UICollectionViewLayout
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override func layoutSubviews() {
        pageControlLayout()
        super.layoutSubviews()
    }
    
    //MARK:- Button Action
    
    @IBAction func showAllButtonAction(_ sender: UIButton) {
        
        self.showallDelegate?.showAllButtonAction(sender: sender as AnyObject, btnSection: sender.tag )
    }
    
    
    
    //MARK:- Business Logics
    func configureCellContent() {
        
        switch segmentType
        {
        case .overDueCalls:
            lblCallsType.text = "OVERDUE CALLS(\(overDueCalls.count))"
        case .todayCalls:
            lblCallsType.text = "TODAY'S CALLS(\(calls.count))"
        case .upcomingCalls:
            lblCallsType.text = "UPCOMING CALLS(\(calls.count))"
        default:
            lblCallsType.text = ""
        }
        
        if segmentType == .overDueCalls
        {
            pageControl.numberOfPages = overDueCalls.count > 5 ? 5 : overDueCalls.count
        }
        else
        {
            pageControl.numberOfPages = calls.count > 5 ? 5 : calls.count
        }

        self.pageControlLayout()
    }
    
    func pageControlLayout()
    {
        
        for (index, dot) in pageControl.subviews.enumerated()
        {
            if index == pageControl.currentPage
            {
                dot.backgroundColor = UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1)
            }
            else
            {
                dot.backgroundColor = UIColor.clear
            }
            
            dot.layer.cornerRadius = dot.frame.size.height / 2
            dot.layer.borderWidth = 1
            dot.layer.borderColor = UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1).cgColor
        }
    }
}

extension DashboardTableViewCell: CustomerCallsboxCollectionViewCellDelegate {
    
    func shipmentHistoryClicked(callList: Calllist) {
        self.delegate?.shipmentHistoryAction(callList: callList)
    }
}

extension DashboardTableViewCell: SummaryPageNavigateDelegate {
    func tickImageClicked(callList: Calllist) {
        self.summaryDelegate?.tickGreenAction(callList: callList)
    }
}

extension DashboardTableViewCell: CallandMailDelegate
{
    
    func callandMail(calllist: Calllist) {
        self.delegateCallMail.CallMail(calllist: calllist)
    }
    
    
}

extension DashboardTableViewCell: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        if segmentType == .overDueCalls
        {
            return overDueCalls.count > 5 ? 5 : overDueCalls.count
        }
        else
        {
            return calls.count > 5 ? 5 : calls.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomerCell", for: indexPath) as! CustomerCallsboxCollectionViewCell
        
        cell.delegate = self
        cell.summarydelegate = self
        cell.delegateCall_Mail = self
        cell.btnCallAndMail.tag = indexPath.item
        
        if segmentType == .overDueCalls
        {
            let overDueCallInfo = overDueCalls[indexPath.item]
            cell.configureCellContent(callList: overDueCallInfo.calllist, deviationDays: overDueCallInfo.overDueDaysNo)
        }
        else if segmentType == .todayCalls
        {
            cell.configureCellContent(callList: calls[indexPath.item], deviationDays: 0)
        }
        else
        {
            cell.configureCellContent(callList: calls[indexPath.item], deviationDays: 0,isUpcomingCalls: true)
        }
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let callEntryDetailViewController = getViewControllerInstance(storyboardName: StoryBoardID.callEntry.rawValue, storyboardId: ViewControllerID.callEntryDetailViewController.rawValue) as! CallEntryDetailViewController
        
        if segmentType == .overDueCalls
        {
            callEntryDetailViewController.callDetail = overDueCalls[indexPath.item].calllist
        }
        else
        {
            callEntryDetailViewController.callDetail = calls[indexPath.item]
        }
        dashboardViewController.navigationController?.pushViewController(callEntryDetailViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
             return CGSize(width: (UIScreen.main.bounds.width), height: 155.0 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0.0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        if let indexPath = collectionView.indexPathForItem(at: visiblePoint)
        {
            pageControl.currentPage = indexPath.row
        }
    }
    
}
