//
//  AbsenceRow.swift
//  AbsenceReport
//
//  Created by Achintha kahawalage on 2026-08-04.
//

import SwiftUI

struct AbsenceRow: View {
    let absence: Absence
    let hasConflict: Bool
    var showsEmployeeName: Bool = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            
            if showsEmployeeName {
                Text(absence.employee.fullName)
                    .font(.headline)
            }
            
            Text(
                absence.startDate.formattedRange(endDate: absence.endDate)
            )
            .font(.subheadline)
            
            HStack {
                Text(absence.absenceType.displayName)
                    .font(.subheadline)
                
                Spacer()
                if hasConflict {
                    Label("Conflict", systemImage: "exclamationmark.triangle.fill")
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }
            
            Text(absence.approved ? "Approved" : "Pending")
                .font(.caption)
        }
        .padding(.vertical, 4)
        
    }
}
