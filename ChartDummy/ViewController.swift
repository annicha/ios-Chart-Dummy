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
        
        let goalEntries: [BarChartDataEntry] = {
            var entries: [BarChartDataEntry] = []
            
            guard let startDate = MockProgress.shared.startDate else { return []}
            print("startdate: \(DateHelper.dateStringFrom(date: startDate))")
            let diff = Calendar.current.dateComponents([.day], from: startDate, to: Date())
            let dayDiff = diff.day
            
            if let difference = dayDiff,
                difference <= 7 {
                for (index, goal) in MockProgress.shared.goal.enumerated() {
                    guard let dayDiff = dayDiff,
                        index <= dayDiff else { print("🍒 Index is higher than diffday. Printing from \(#function) \n In \(String(describing: MockProgress.self)) 🍒"); break}
                    entries += [BarChartDataEntry(x: Double(index + 1), y: Double(goal))]
                }
            } else {
                let latestProgress = MockProgress.shared.goal.dropFirst(MockProgress.shared.goal.count - 7)
                for (index, goal) in latestProgress.enumerated() {
                    guard let dayDiff = dayDiff,
                        index <= dayDiff else { print("🍒 Index is higher than diffday. Printing from \(#function) \n In \(String(describing: MockProgress.self)) 🍒"); break}
                    entries += [BarChartDataEntry(x: Double(index + 1), y: Double(goal))]
                }
            }
            
            return entries
        }()
        
        
        let goalSet = BarChartDataSet(entries: goalEntries, label: "Goal")
        goalSet.setColor(UIColor.blue)
        
        let actualEntries: [BarChartDataEntry] = {
            var entries: [BarChartDataEntry] = []
            
            guard let startDate = MockProgress.shared.startDate else { return []}

            let dayDiff = Calendar.current.dateComponents([.day], from: startDate, to: Date()).day
            
            if let difference = dayDiff,
                difference <= 7 {
                for (index, progress) in MockProgress.shared.progress.enumerated() {
                    guard let dayDiff = dayDiff,
                        index <= dayDiff else { print("🍒 Index is higher than diffday. Printing from \(#function) \n In \(String(describing: MockProgress.self)) 🍒"); break}
                    entries += [BarChartDataEntry(x: Double(index + 1), y: Double(progress))]
                }
            } else {
                let latestProgress = MockProgress.shared.progress.dropFirst(MockProgress.shared.progress.count - 7)
                for (index, progress) in latestProgress.enumerated() {
                    guard let dayDiff = dayDiff,
                        index <= dayDiff else { print("🍒 Index is higher than diffday. Printing from \(#function) \n In \(String(describing: MockProgress.self)) 🍒"); break}
                    entries += [BarChartDataEntry(x: Double(index + 1), y: Double(progress))]
                }
            }
            
            return entries
        }()
        
        let actualSet = BarChartDataSet(entries: actualEntries, label: "Actual")
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
}

