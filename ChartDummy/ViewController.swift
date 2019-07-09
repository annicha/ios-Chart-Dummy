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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let date = MockProgress.shared.startDate {
            print(MockProgress.shared.goal.count)
            print(DateHelper.dateStringFrom(date: date))
            print(Calendar.current.dateComponents([.day], from: date, to: Date()).day)
        }
        
        /* Goal vs actual history chart */
        setUpHistoryBar()
    }

    func setUpHistoryBar(){
    
        let groupSpace = 0.5
        let barSpace = 0.0
        let barWidth = 0.25
        
        // make description appear on top
        barChartView.drawValueAboveBarEnabled = true
        
        // disable zooming
        barChartView.pinchZoomEnabled = false
        barChartView.scaleXEnabled = false
        barChartView.scaleYEnabled = false
        
        let goalEntries: [BarChartDataEntry] = getEntry(fromArray: MockProgress.shared.goal)
        let actualEntries: [BarChartDataEntry] = getEntry(fromArray: MockProgress.shared.progress)

        let goalSet = BarChartDataSet(entries: goalEntries, label: "Goal")
        let actualSet = BarChartDataSet(entries: actualEntries, label: "Actual")

        goalSet.setColor(UIColor.blue)
        actualSet.setColor(UIColor.green)

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
    
    func getProgressArray(fromArray array: [Int], fromDiff diff: Int, atNumberOfDays days: Int) -> [Int] {
        let droppedFirstArray = array.dropFirst(diff - days + 1)
        return droppedFirstArray.dropLast(array.count - diff - 1)
    }
    
    func getEntry(fromArray array: [Int]) -> [BarChartDataEntry] {
        var entries: [BarChartDataEntry] = []
        
        guard let startDate = MockProgress.shared.startDate,
            let dayDiff = Calendar.current.dateComponents([.day], from: startDate, to: Date()).day else { return []}
        
        let selectedPortion = getProgressArray(fromArray: array, fromDiff: dayDiff, atNumberOfDays: 7)
        
        for (index, amount) in selectedPortion.enumerated() {
            entries += [BarChartDataEntry(x: Double(index + 1), y: Double(amount))]
        }
        
        return entries
    }
}

