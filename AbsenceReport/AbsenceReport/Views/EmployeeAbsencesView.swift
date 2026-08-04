//
//  EmployeeAbsencesView.swift
//  AbsenceReport
//
//  Created by Achintha kahawalage on 2026-08-04.
//

import SwiftUI

struct EmployeeAbsencesView: View {
    let employee: Employee
    let absences: [Absence]
    let conflicts: [Int: Bool]
    
    var body: some View {
        List {
            Section {
                Text("\(absences.count) absence\(absences.count == 1 ? "" : "s")")
            }
            
            ForEach(absences) { absence in
                AbsenceRow(
                    absence: absence,
                    hasConflict: conflicts[absence.id] ?? false,
                    showsEmployeeName: false
                )
            }
        }
        .navigationTitle(employee.fullName)
    }
}
