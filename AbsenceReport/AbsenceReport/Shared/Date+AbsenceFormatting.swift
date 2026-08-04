//
//  Date+AbsenceFormatting.swift
//  AbsenceReport
//
//  Created by Achintha kahawalage on 2026-08-04.
//

import Foundation

extension Date {

    static let absenceDateStyle =
        Date.FormatStyle()
            .day()
            .month(.abbreviated)
            .year()

    func formattedRange(endDate: Date) -> String {
        "\(formatted(Self.absenceDateStyle)) – \(endDate.formatted(Self.absenceDateStyle))"
    }
}
