//
//  Absence.swift
//  AbsenceReport
//
//  Created by Achintha kahawalage on 2026-08-01.
//

import Foundation


struct Absence: Decodable, Identifiable, Equatable{
    let id: Int
    let startDate: Date
    let days: Int
    let absenceType: AbsenceType
    let employee: Employee
    let approved: Bool
    var endDate: Date {
        let daysToAdd = max(0, days - 1)
        return Calendar.current.date(byAdding: .day, value: daysToAdd, to: startDate) ?? startDate
    }
}

enum AbsenceType: String, Decodable {
    case annualLeave = "ANNUAL_LEAVE"
    case sickness = "SICKNESS"
    case medical = "MEDICAL"
    case unknown
    
    var displayName: String {
        switch self {
        case .annualLeave: return "Annual leave"
        case .sickness: return "Sickness"
        case .medical: return "Medical"
        case .unknown: return "Other"
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = AbsenceType(rawValue: rawValue) ?? .unknown
    }
}




