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
        
        let groupSpace = 0.5
        let barSpace = 0.0
        let barWidth = 0.25

        /* Goal vs actual history */
        
        barChartView.drawValueAboveBarEnabled = true
        
        let week1MathGoal = [55,100,80,0,0,0,80]
        let goalEntries: [BarChartDataEntry] = {
            var entries: [BarChartDataEntry] = []
            for (index, goal) in week1MathGoal.enumerated() {
                entries += [BarChartDataEntry(x: Double(index + 1), y: Double(goal))]
            }
            return entries
        }()
        

        let goalSet = BarChartDataSet(entries: goalEntries, label: "Goal")
        goalSet.setColor(UIColor.blue)
        
        let week1MathActual = [0,50,80,0,0,0,50]
        let actualEntries: [BarChartDataEntry] = {
            var entries: [BarChartDataEntry] = []
            for (index, goal) in week1MathActual.enumerated() {
                entries += [BarChartDataEntry(x: Double(index + 1), y: Double(goal))]
            }
            return entries
        }()
        let actualSet = BarChartDataSet(entries: actualEntries, label: "Actual")
        actualSet.setColor(UIColor.green)
        
        let groupData = BarChartData(dataSets: [goalSet, actualSet])
    
        groupData.barWidth = barWidth
        barChartView.data = groupData
        groupData.groupBars(fromX: groupSpace, groupSpace: groupSpace, barSpace: barSpace)

        
        
        barChartView.notifyDataSetChanged()
    }


}

