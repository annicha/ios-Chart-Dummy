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
    
    let startDate = Date(timeIntervalSince1970: 1562182964)
    let goal = [7, 7, 5, 5, 5, 0, 0]
    let progress = [0, 7, 8, 10, 12, 0, 0]
    
}
