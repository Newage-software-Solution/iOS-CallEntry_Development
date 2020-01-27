//
//  DashboardLineChartCollectionViewCell.swift
//  CallEntry
//
//  Created by HMSPL on 09/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit
import Charts

class DashboardLineChartCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var barChartView: BarChartView!
    
    var totalCallsCount:[Double]  = []
    var deviationCallsCount:[Double] = []
    
    var weekDays: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //barChartView.legend.enabled = false
        barChartView.scaleYEnabled = false
        barChartView.scaleXEnabled = false
        barChartView.pinchZoomEnabled = false
        barChartView.doubleTapToZoomEnabled = false
        barChartView.xAxis.drawGridLinesEnabled = false
        
        //viewLineChart.animation.enabled = true
        //viewLineChart.area = true
        //viewLineChart.x.labels.visible = true
        //viewLineChart.y.labels.visible = true
    }
    
    func configureCellContent(lineChartData: LineChartData) {
        totalCallsCount = []
        deviationCallsCount = []
        
        //viewLineChart.x.grid.count = 5
        //viewLineChart.y.grid.count = 5
        //viewLineChart.x.labels.values = lineChartData.weekDays.map({ $0.day })
        //viewLineChart.y.labels.values = lineChartData.weekDays.map( {String($0.totalCallCount)})
        
        let months = lineChartData.weekDays.map({ $0.day })
        for weekDay in lineChartData.weekDays
        {
            totalCallsCount.append(Double(Int(weekDay.totalCallCount)))
            deviationCallsCount.append(Double(weekDay.deviationCallCount))
        }
    
        //viewLineChart.addLine(deviationCallsCount) //Deviation Calls
       //viewLineChart.addLine(totalCallsCount) //Total Calls
        
        //barChartView.delegate = self
        barChartView.noDataText = "You need to provide data for the chart."
        barChartView.chartDescription?.text = ""
        
        let xaxis = barChartView.xAxis
        //xaxis.valueFormatter = axisFormatDelegate
        xaxis.drawGridLinesEnabled = true
        xaxis.labelPosition = .bottom
        xaxis.centerAxisLabelsEnabled = true
        xaxis.labelFont = UIFont(name: "Roboto-Medium", size: 11)!
        xaxis.labelTextColor = UIColor(red: 0.24, green: 0.24, blue: 0.24, alpha: 0.7)
        xaxis.valueFormatter = IndexAxisValueFormatter(values: months)
        xaxis.granularity = 1
        
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.maximumFractionDigits = 1
        
        let yaxis = barChartView.leftAxis
        yaxis.spaceTop = 0.35
        yaxis.axisMinimum = 0
        yaxis.labelFont = UIFont(name: "Roboto-Medium", size: 11)!
        yaxis.labelTextColor = UIColor(red: 0.24, green: 0.24, blue: 0.24, alpha: 0.7)
        yaxis.drawGridLinesEnabled = false
        
        barChartView.rightAxis.enabled = false
        
        barChartView.noDataText = "You need to provide data for the chart."
        var dataEntries: [BarChartDataEntry] = []
        var dataEntries1: [BarChartDataEntry] = []
        
        for i in 0..<months.count {
            
            let dataEntry = BarChartDataEntry(x: Double(i) , y: totalCallsCount[i])
            dataEntries.append(dataEntry)
            
            let dataEntry1 = BarChartDataEntry(x: Double(i) , y: deviationCallsCount[i])
            dataEntries1.append(dataEntry1)
            
            //stack barchart
            //let dataEntry = BarChartDataEntry(x: Double(i), yValues:  [self.unitsSold[i],self.unitsBought[i]], label: "groupChart")
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Calls")//Unit sold
        let chartDataSet1 = BarChartDataSet(entries: dataEntries1, label: "Delay")//Unit Bought
        chartDataSet.colors = [UIColor(red: 28/255, green: 190/255, blue: 47/255, alpha: 1)]
        chartDataSet.valueFont = UIFont(name: "Roboto-Medium", size: 11)!
        chartDataSet1.colors = [UIColor(red: 248/255, green: 88/255, blue: 88/255, alpha: 1)]
        chartDataSet1.valueFont = UIFont(name: "Roboto-Medium", size: 11)!
        
        let dataSets: [BarChartDataSet] = [chartDataSet,chartDataSet1]
        //[UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
        //chartDataSet.colors = ChartColorTemplates.colorful()
        
        let chartData = BarChartData(dataSets: dataSets)
    
        let groupSpace = 0.3
        let barSpace = 0.05
        let barWidth = 0.3
        // (0.3 + 0.05) * 2 + 0.3 = 1.00 -> interval per "group"
        
        let groupCount = months.count
        let startYear = 0
        
        
        chartData.barWidth = barWidth;
        barChartView.xAxis.axisMinimum = Double(startYear)
        let gg = chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        print("Groupspace: \(gg)")
        barChartView.xAxis.axisMaximum = Double(startYear) + gg * Double(groupCount)
        
        chartData.groupBars(fromX: Double(startYear), groupSpace: groupSpace, barSpace: barSpace)
        //chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        barChartView.notifyDataSetChanged()
        
        let format = NumberFormatter()
        format.numberStyle = NumberFormatter.Style.none
        format.maximumFractionDigits = 1
        format.multiplier = 1.0
        let formatter = DefaultValueFormatter(formatter: format)
        chartData.setValueFormatter(formatter)
        
        //chartData.setValueFont(UIFont(name: "Roboto-Medium", size: 11))
        chartData.setValueTextColor(UIColor(red: 0.24, green: 0.24, blue: 0.24, alpha: 0.7))
        
        barChartView.data = chartData
        
        //background color
        //barChartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
        
        //chart animation
        barChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
        //print("\(entry.x) in \(months[Int(entry.x)])")
    }
}


extension BarChartView {
    
    open class BarChartFormatter: NSObject, IAxisValueFormatter {
        
        var labels: [String] = []
        
        public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            return labels[Int(value)]
        }
        
        init(labels: [String]) {
            super.init()
            self.labels = labels
        }
    }
}
