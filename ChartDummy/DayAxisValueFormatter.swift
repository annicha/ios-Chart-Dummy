//
//  DayAxisValueFormatter.swift
//  ChartsDemo-iOS
//
//  Created by Jacob Christie on 2017-07-09.
//  Copyright © 2017 jc. All rights reserved.
//

import Foundation
import Charts

public class DayAxisValueFormatter: NSObject, IAxisValueFormatter {
    weak var chart: BarLineChartViewBase?
    
    init(chart: BarLineChartViewBase) {
        self.chart = chart
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let value = Int(value)
        
        guard let currentDate = Calendar.current.date(byAdding: .day, value: -(7 - value), to: Date()) else { return "error"}

        return Calendar.current.isDateInToday(currentDate) ? "Today" : DateHelper.dateStringFrom(date: currentDate)

    }
    
}
