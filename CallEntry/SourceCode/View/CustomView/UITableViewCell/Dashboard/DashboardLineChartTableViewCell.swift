//
//  DashboardLineChartTableViewCell.swift
//  CallEntry
//
//  Created by Rajesh on 15/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

protocol ScrollDelegate {
    func nextChartUpdate(chartNo: Int)
}

class DashboardLineChartTableViewCell: UITableViewCell {

    @IBOutlet weak var btnNextChart: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!

    var delegate: ScrollDelegate!
    
    var lineChartData: [LineChartData] = []
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        collectionView.register(UINib.init(nibName: "DashboardLineChartCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.minimumLineSpacing = 0
        collectionViewFlowLayout.minimumInteritemSpacing = 0
        collectionViewFlowLayout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = collectionViewFlowLayout as UICollectionViewLayout
        
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    
    func chartArrowUpdate()
    {
        let indexPath = collectionView.indexPathForItem(at: visibleRect())
      
        if indexPath?.item == 0
        {
            self.collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .right, animated: true)
            
        }
        else
        {
            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .right, animated: true)
        }

    }
    
    @IBAction func nextChartButtonAction(_ sender: Any)
    {
        let animation = CABasicAnimation(keyPath: "backgroundColor")
        animation.fromValue = UIColor.lightGray.withAlphaComponent(0.2).cgColor
        animation.toValue = UIColor.gray.withAlphaComponent(0.2).cgColor
        self.btnNextChart.layer.add(animation, forKey: "backgroundColor")
       self.chartArrowUpdate()
       
    }
}

extension DashboardLineChartTableViewCell: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.delegate.nextChartUpdate(chartNo: 0) //Initialization first time for total and deviation calls
        return lineChartData.count //For OverDueCalls and UpcomingCalls
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DashboardLineChartCollectionViewCell
        cell.configureCellContent(lineChartData: lineChartData[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: UIScreen.main.bounds.width - 36.0, height: 165.0 )
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        
        if let indexPath = collectionView.indexPathForItem(at: visibleRect())
        {
             self.delegate.nextChartUpdate(chartNo: indexPath.row)
            if indexPath.item == 0
            {
                self.btnNextChart.transform = CGAffineTransform.init(rotationAngle: 0)
            }
            else
            {
                self.btnNextChart.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi)
            }
            
        }
        
    }
    
    
    func visibleRect() -> CGPoint
    {
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        return visiblePoint
    }
    
}

