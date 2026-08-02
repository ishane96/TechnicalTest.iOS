//
//  MockAbsenceService.swift
//  AbsenceReport
//
//  Created by Achintha kahawalage on 2026-08-02.
//

import Foundation
@testable import AbsenceReport

struct MockAbsenceService: AbsenceServiceProtocol {

    let absences: [Absence]
    let conflict: Bool
    let absencesError: Error?
    let conflictError: Error?

    init(
        absences: [Absence] = [],
        conflict: Bool = false,
        absencesError: Error? = nil,
        conflictError: Error? = nil
    ) {
        self.absences = absences
        self.conflict = conflict
        self.absencesError = absencesError
        self.conflictError = conflictError
    }

    func fetchAbsences() async throws -> [Absence] {
        if let absencesError {
            throw absencesError
        }

        return absences
    }

    func fetchConflict(for absenceID: Int) async throws -> Bool {
        if let conflictError {
            throw conflictError
        }

        return conflict
    }
}
