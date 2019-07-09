//
//  MockProgress.swift
//  ChartDummy
//
//  Created by Annicha Hanwilai on 7/9/19.
//  Copyright © 2019 Annicha Hanwilai. All rights reserved.
//

import Foundation

struct DateHelper {
    static func dateStringFrom(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        return dateFormatter.string(from: date)
    }
}


class MockProgress {

    static let shared = MockProgress()
    private init (){}
    
    let goal =     [7, 7, 5, 5, 7, 0, 9, 5, 5, 5, 13, 5, 5, 9, 6]
    let progress = [7, 3, 1, 5, 5, 0, 1, 2, 3, 2, 10, 0, 5, 5, 6]
    var startDate = Calendar.current.date(byAdding: .day, value: -12, to: Date())
}
