//
//  ViewController.swift
//  ChartDummy
//
//  Created by Annicha Hanwilai on 7/8/19.
//  Copyright © 2019 Annicha Hanwilai. All rights reserved.
//
import UIKit
import Charts

class ViewController: UIViewController {

    @IBOutlet weak var barChartView: BarChartView!
    
    @IBOutlet weak var combinedChartView: CombinedChartView!
    
    lazy var customFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.allowsFloats = false
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("🍒🍒 StartDate: \(MockProgress.shared.startDate) ")
        
//        print(ChartDataController.shared.getPlannedEntriesNextWeek(fromArray: MockProgress.shared.goal))
        
        /* Goal vs actual history chart */
        setUpHistoryChart()
        
        setupCombinedChart()
    }

    func setUpHistoryChart(){
    
        let groupSpace = 0.5
        let barSpace = 0.0
        let barWidth = 0.25
        
        // make description appear on top
        barChartView.drawValueAboveBarEnabled = true
        
        // disable zooming
        barChartView.pinchZoomEnabled = false
        barChartView.scaleXEnabled = false
        barChartView.scaleYEnabled = false
        
        let goalEntries: [BarChartDataEntry] = ChartDataController.shared.getPastWeekEntries(fromArray: MockProgress.shared.goal)
        let actualEntries: [BarChartDataEntry] = ChartDataController.shared.getPastWeekEntries(fromArray: MockProgress.shared.progress)

        let goalSet = BarChartDataSet(entries: goalEntries, label: "Goal")
        let actualSet = BarChartDataSet(entries: actualEntries, label: "Actual")

        goalSet.setColor(UIColor.blue)
        actualSet.setColor(UIColor.green)
        
        goalSet.valueFormatter = DefaultValueFormatter(formatter: customFormatter)
        actualSet.valueFormatter = DefaultValueFormatter(formatter: customFormatter)
        
        let groupData = BarChartData(dataSets: [goalSet, actualSet])
        
        groupData.barWidth = barWidth
        barChartView.data = groupData
        
        groupData.groupBars(fromX: groupSpace, groupSpace: groupSpace, barSpace: barSpace)
        
        /* set up labels */
        let xAxis = barChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.valueFormatter = DayAxisValueFormatter(chart: barChartView)
        
        let leftAxis = barChartView.leftAxis
        leftAxis.axisMinimum = 0
        
        let rightAxis = barChartView.rightAxis
        rightAxis.axisMinimum = 0
        
        barChartView.notifyDataSetChanged()
    }
    
   
    
    
    /* ----------------------
 
     Second Chart Stuff
     
    --------------------------*/
    
    func setupCombinedChart(){
        
        combinedChartView.pinchZoomEnabled = false
        combinedChartView.scaleXEnabled = false
        combinedChartView.scaleYEnabled = false
        
        combinedChartView.chartDescription?.enabled = true
        
        combinedChartView.drawBarShadowEnabled = false
        combinedChartView.highlightFullBarEnabled = true
        
        combinedChartView.drawOrder = [DrawOrder.bar.rawValue, DrawOrder.line.rawValue]
        
        let data = CombinedChartData()
        data.lineData = generateAccumulativeLineChartData()
        data.barData = generateEstimatedWorkBarChartData()
        
        
        /* set up labels */
        let xAxis = combinedChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 9)
        xAxis.axisMinimum = 0.5
        
        xAxis.valueFormatter = ForecastAxisValueFormatter(chart: combinedChartView)
        
        let leftAxis = combinedChartView.leftAxis
        leftAxis.axisMinimum = 0
        
        let rightAxis = combinedChartView.rightAxis
        rightAxis.axisMinimum = 0
        
        combinedChartView.data = data
        
        combinedChartView.setVisibleXRangeMinimum(8.0)
        
    }
    
    func generateAccumulativeLineChartData() -> LineChartData {
        let goalEntries: [BarChartDataEntry] = ChartDataController.shared.getPastWeekEntries(fromArray: MockProgress.shared.goal)
        
        let set = LineChartDataSet(entries: goalEntries, label: "Something")
        set.setColor(UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1))
        set.lineWidth = 2.5
        set.setCircleColor(UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1))
        set.circleRadius = 5
        set.circleHoleRadius = 2.5
        set.fillColor = UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1)
        set.mode = .cubicBezier
        set.drawValuesEnabled = false
        set.valueFont = .systemFont(ofSize: 10)
        set.valueTextColor = UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1)
        
        set.axisDependency = .left
        
        return LineChartData(dataSet: set)
    }
    
    func generateEstimatedWorkBarChartData() -> BarChartData {
        let groupSpace = 0.5
        let barSpace = 0.0
        let barWidth = 0.25
        
        let goalEntries: [BarChartDataEntry] = ChartDataController.shared.getPlannedEntriesNextWeek(fromArray: MockProgress.shared.goal)
        let goalEntries2: [BarChartDataEntry] = ChartDataController.shared.getPastWeekEntries(fromArray: MockProgress.shared.goal)
        
        let goalSet = BarChartDataSet(entries: goalEntries, label: "Planned")
        let goalSet2 = BarChartDataSet(entries: goalEntries2, label: "A Copy")
        goalSet.setColor(UIColor.red)
        goalSet2.setColor(UIColor.gray)
        
        goalSet.valueFormatter = DefaultValueFormatter(formatter: customFormatter)
        goalSet2.valueFormatter = DefaultValueFormatter(formatter: customFormatter)

        
        let groupData = BarChartData(dataSets: [goalSet, goalSet2])
        groupData.barWidth = barWidth
        groupData.groupBars(fromX: groupSpace, groupSpace: groupSpace, barSpace: barSpace)
        
        return groupData
    }
}

