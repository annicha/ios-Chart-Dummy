//
//  HistoryChartController.swift
//  ChartDummy
//
//  Created by Annicha Hanwilai on 7/10/19.
//  Copyright © 2019 Annicha Hanwilai. All rights reserved.
//

import Foundation
import Charts

class ChartDataController {
    
    static let shared = ChartDataController()
    
    /* Methods for getting needed part of the log */
    func getSelectedPartWeekBefore(fromArray array: [Int], fromDiff diff: Int, atNumberOfDays days: Int) -> [Int] {
        let droppedFirstArray = array.dropFirst(diff - days + 1)
        return droppedFirstArray.dropLast(array.count - diff - 1)
    }
    
    func getSelectedPartWeekAfter(fromArray array: [Int], fromDiff diff: Int, atNumberOfDays days: Int) -> [Int] {
        
        guard array.count - diff > days else { print("🍒 Array is not long enough to return all week. Printing from \(#function) \n In \(String(describing: ChartDataController.self)) 🍒"); return [] }
        
        let droppedFirstArray = array.dropFirst(diff)
        return droppedFirstArray.dropLast(array.count - diff - days)
    }
    
    
    /* Method for turn partial array into actual chart entry */
    
    // Past week log
    func getPastWeekEntries(fromArray array: [Int]) -> [BarChartDataEntry] {
        var entries: [BarChartDataEntry] = []
        
        // get started from the recorded start date and return the difference between that date and today
        guard let startDate = MockProgress.shared.startDate,
            let dayDiff = Calendar.current.dateComponents([.day], from: startDate, to: Date()).day else { return []}
        
        print("Day diff is \(dayDiff) 🍒🍒🍒")
        
        let selectedPortion = getSelectedPartWeekBefore(fromArray: array, fromDiff: dayDiff, atNumberOfDays: 8)
        
        for (index, amount) in selectedPortion.enumerated() {
            entries += [BarChartDataEntry(x: Double(index + 1), y: Double(amount))]
        }
        
        return entries
    }
    
    // Next week log
    func getPlannedEntriesNextWeek(fromArray array: [Int]) -> [BarChartDataEntry]{
        var entries: [BarChartDataEntry] = []
        
        guard let startDate = MockProgress.shared.startDate,
            let dayDiff = Calendar.current.dateComponents([.day], from: startDate, to: Date()).day else { return []}
        
        let selectedPortion = getSelectedPartWeekAfter(fromArray: array, fromDiff: dayDiff, atNumberOfDays: 8)
        
        for (index, amount) in selectedPortion.enumerated() {
            entries += [BarChartDataEntry(x: Double(index + 1), y: Double(amount))]
        }
        
        return entries
    }
    
    /* Predictions */
    
    // Accumulation with 0 work perday
    
    // Accumulation with some work at same amount everyday
    
    // Accumulation at average amount every day
}
