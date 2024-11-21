//
//  Day.swift
//  pp
//
//  Created by Zhdanov Konstantin on 20.11.2024.
//

import Foundation
import SwiftData

@Model
class Day {
    var id: UUID = UUID()
    var date: Date
    var sleepRecords: [SleepRecord]
    
    init(date: Date) {
        self.date = date
        self.sleepRecords = []
    }
}
