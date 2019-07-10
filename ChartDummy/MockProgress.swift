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
    
    let goal =     [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19]
    let progress = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19]
    var startDate = Calendar.current.date(byAdding: .day, value: -10, to: Date())
}
