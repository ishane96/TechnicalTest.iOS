//
//  AbsenceRow.swift
//  AbsenceReport
//
//  Created by Achintha kahawalage on 2026-08-04.
//

import SwiftUI

struct AbsenceRow: View {
    let absence: Absence
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            
            Text(absence.employee.fullName)
                .font(.headline)
            
            Text(
                absence.startDate.formattedRange(endDate: absence.endDate)
            )
            .font(.subheadline)
            
            Text(absence.absenceType.displayName)
                .font(.subheadline)
            
            Text(absence.approved ? "Approved" : "Pending")
                .font(.caption)
        }
        .padding(.vertical, 4)
    }
}
