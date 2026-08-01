//
//  Employee.swift
//  AbsenceReport
//
//  Created by Achintha kahawalage on 2026-08-01.
//

import Foundation

struct Employee: Codable, Hashable, Identifiable {
    let id: String
    let firstName: String
    let lastName: String
    var fullName: String {
        "\(firstName) \(lastName)"
    }
}
