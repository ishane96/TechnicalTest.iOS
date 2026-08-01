//
//  AbsenceDecodingTests.swift
//  AbsenceReportTests
//
//  Created by Achintha kahawalage on 2026-08-01.
//

import XCTest
@testable import AbsenceReport

final class AbsenceDecodingTests: XCTestCase {
    
    func testDecodeAbsencesSuccessfully() throws {
           let absences = try FixtureLoader.decode(
               [Absence].self,
               from: "absences_stub"
           )

           XCTAssertEqual(absences.count, 6)

           let first = absences[0]
           XCTAssertEqual(first.days, 9)
           XCTAssertEqual(first.approved, true)
           XCTAssertEqual(first.employee.firstName, "Rahaf")
           XCTAssertEqual(first.employee.lastName, "Deckard")
       }

       func testStartDateDecodesISO8601WithFractionalSeconds() throws {
           let absences = try FixtureLoader.decode(
               [Absence].self,
               from: "absences_stub"
           )

           let date = absences[0].startDate

           let calendar = Calendar(identifier: .gregorian)

           let components = calendar.dateComponents(
               in: TimeZone(identifier: "UTC")!,
               from: date
           )

           XCTAssertEqual(components.year, 2022)
           XCTAssertEqual(components.month, 5)
           XCTAssertEqual(components.day, 28)
           XCTAssertEqual(components.hour, 4)
           XCTAssertEqual(components.minute, 39)
           XCTAssertEqual(components.second, 6)
       }

    func testEndDateIsSameDayWhenDurationIsOneDay() throws {
            let absences = try FixtureLoader.decode(
                [Absence].self,
                from: "absences_stub"
            )

            // Record with days == 1 (index 1)
            let absence = absences[1]

            XCTAssertTrue(
                Calendar.current.isDate(
                    absence.startDate,
                    inSameDayAs: absence.endDate
                )
            )
        }

        func testEndDateIsNotBeforeStartDateWhenDurationIsZero() throws {
            let absences = try FixtureLoader.decode(
                [Absence].self,
                from: "absences_stub"
            )

            // Record with days == 0 (index 3)
            let absence = absences[3]

            XCTAssertGreaterThanOrEqual(
                absence.endDate,
                absence.startDate
            )
        }

        func testUnknownAbsenceTypeFallsBackToUnknown() throws {
            let absences = try FixtureLoader.decode(
                [Absence].self,
                from: "absences_unknown_type"
            )

            let absence = try XCTUnwrap(absences.first)

            XCTAssertEqual(absence.absenceType, .unknown)
        }

        func testMalformedFixtureThrowsKeyNotFound() {
            XCTAssertThrowsError(
                try FixtureLoader.decode(
                    [Absence].self,
                    from: "absences_malformed"
                )
            ) { error in
                guard case DecodingError.keyNotFound = error else {
                    return XCTFail("Expected DecodingError.keyNotFound, got \(error)")
                }
            }
        }
}
