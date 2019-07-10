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
    
    // formatter for removing floting point
    lazy var noFloatFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.allowsFloats = false
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Goal vs actual history chart */
        setUpHistoryChart()
        
        /* Prediction Chart */
        setupPredictionChart()
    }

    
    // MARK: - Chart
    func setUpHistoryChart(){
        
        // make description appear on top
        barChartView.drawValueAboveBarEnabled = true
        
        // disable zooming
        barChartView.pinchZoomEnabled = false
        barChartView.scaleXEnabled = false
        barChartView.scaleYEnabled = false
        
        // create entries
        let goalEntries: [BarChartDataEntry] = ChartDataController.shared.getPastWeekEntries(fromArray: MockProgress.shared.goal)
        let actualEntries: [BarChartDataEntry] = ChartDataController.shared.getPastWeekEntries(fromArray: MockProgress.shared.progress)

        /* SETS */
        // create chart set from entries
        let goalSet = BarChartDataSet(entries: goalEntries, label: "Goal")
        let actualSet = BarChartDataSet(entries: actualEntries, label: "Actual")

        // Colors
        goalSet.setColor(UIColor.blue)
        actualSet.setColor(UIColor.green)
        
        // Remove 0 from label value
        goalSet.valueFormatter = DefaultValueFormatter(formatter: noFloatFormatter)
        actualSet.valueFormatter = DefaultValueFormatter(formatter: noFloatFormatter)
        
        let groupData = BarChartData(dataSets: [goalSet, actualSet])
        
        
        // set up spaces and size
        let groupSpace = 0.5
        let barSpace = 0.0
        let barWidth = 0.25
        
        groupData.barWidth = barWidth
        barChartView.data = groupData
        
        groupData.groupBars(fromX: groupSpace, groupSpace: groupSpace, barSpace: barSpace)
        
        /* set up label appearance */
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
    
    func setupPredictionChart(){
        
        combinedChartView.pinchZoomEnabled = false
        combinedChartView.scaleXEnabled = false
        combinedChartView.scaleYEnabled = false
        
        combinedChartView.chartDescription?.enabled = true
        
        combinedChartView.drawBarShadowEnabled = false
        combinedChartView.highlightFullBarEnabled = true
        
        // assign data to chart
        combinedChartView.drawOrder = [DrawOrder.bar.rawValue, DrawOrder.line.rawValue]
        
        let data = CombinedChartData()
        data.lineData = generateAccumulativeLineChartData()
        data.barData = generateEstimatedWorkBarChartData()
        
        
        /* set up labels appearance */
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
        
        // Make sure the chart does not clip off
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
        
        goalSet.valueFormatter = DefaultValueFormatter(formatter: noFloatFormatter)
        goalSet2.valueFormatter = DefaultValueFormatter(formatter: noFloatFormatter)

        
        let groupData = BarChartData(dataSets: [goalSet, goalSet2])
        groupData.barWidth = barWidth
        groupData.groupBars(fromX: groupSpace, groupSpace: groupSpace, barSpace: barSpace)
        
        return groupData
    }
}

