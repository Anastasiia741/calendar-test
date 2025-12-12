//  Extensions.swift
//  Calendar-test
//  Created by Анастасия Набатова on 12/12/25.

import Foundation

enum AppDateFormatters {
    static let monthTitleRU: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ru_RU")
        f.dateFormat = "LLLL yyyy"
        return f
    }()

    static let timeHHmm: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f
    }()

    static let dateTimeRU: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ru_RU")
        f.dateFormat = "d MMMM yyyy, HH:mm"
        return f
    }()
}


extension Date {
    var monthTitleRU: String { AppDateFormatters.monthTitleRU.string(from: self).capitalized }
    var timeHHmm: String { AppDateFormatters.timeHHmm.string(from: self) }
    var dateTimeRU: String { AppDateFormatters.dateTimeRU.string(from: self) }
}


extension Calendar {
    func monthDays(for month: Date) -> [Date?] {
        guard let interval = dateInterval(of: .month, for: month) else { return [] }

        let start = interval.start
        let firstWeekday = component(.weekday, from: start)
        _ = (firstWeekday - firstWeekday + 7) % 7

        let realShift = (firstWeekday - self.firstWeekday + 7) % 7

        var result: [Date?] = Array(repeating: nil, count: realShift)

        var date = start
        while date < interval.end {
            result.append(date)
            date = self.date(byAdding: .day, value: 1, to: date) ?? interval.end
        }
        return result
    }

    func dayNumberString(_ date: Date) -> String {
        String(component(.day, from: date))
    }
}


extension Double {
    var kmString: String { String(format: "%.1f км", self / 1000) }

    var mmssString: String {
        let total = Int(self)
        let m = total / 60
        let s = total % 60
        return String(format: "%02d:%02d", m, s)
    }
}
