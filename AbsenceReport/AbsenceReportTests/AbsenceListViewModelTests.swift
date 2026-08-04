//
//  AbsenceListViewModelTests.swift
//  AbsenceReportTests
//
//  Created by Achintha kahawalage on 2026-08-02.
//

import XCTest
@testable import AbsenceReport

@MainActor
final class AbsenceListViewModelTests: XCTestCase {

    func test_initialState_isIdle() async {
        let service = MockAbsenceService()
        let viewModel = AbsenceListViewModel(service: service)

        XCTAssertEqual(viewModel.state, .idle)
    }

    func test_load_success_setsLoadedState() async throws {
        let absences = try FixtureLoader.loadAbsences()
        let service = MockAbsenceService(absences: absences)
        let viewModel = AbsenceListViewModel(service: service)

        await viewModel.load()

        guard case let .loaded(result) = viewModel.state else {
            return XCTFail("Expected loaded state")
        }

        XCTAssertEqual(result.count, absences.count)
    }

    func test_load_emptyResponse_setsEmptyState() async {
        let service = MockAbsenceService(absences: [])
        let viewModel = AbsenceListViewModel(service: service)

        await viewModel.load()

        XCTAssertEqual(viewModel.state, .empty)
    }

    func test_load_failure_setsFailedState() async {
        let service = MockAbsenceService(
            absencesError: TestError.network
        )
        let viewModel = AbsenceListViewModel(service: service)

        await viewModel.load()

        XCTAssertEqual(
            viewModel.state,
            .failed(TestError.network.localizedDescription)
        )
    }

    func test_sortedAbsences_byName_usesStartDateAsTiebreaker() async throws {
        let absences = try FixtureLoader.loadAbsences()
        let service = MockAbsenceService(absences: absences)
        let viewModel = AbsenceListViewModel(service: service)

        await viewModel.load()

        viewModel.sortOption = .employeeName

        let sorted = viewModel.sortedAbsences

        XCTAssertEqual(
            sorted.map { $0.employee.fullName },
            [
                "Alexi Schramm",
                "Alexi Schramm",
                "Jabez Nasser",
                "Rahaf Deckard",
                "Raniya Otte",
                "Reuben Keene",
            ]
        )

        let alexiDates = sorted
            .filter { $0.employee.fullName == "Alexi Schramm" }
            .map(\.startDate)

        XCTAssertEqual(alexiDates.count, 2)
        
        XCTAssertEqual(
            alexiDates,
            alexiDates.sorted()
        )
    }

    func test_sortedAbsences_byType_ordersByTypeName() async throws {
        let absences = try FixtureLoader.loadAbsences()
        let service = MockAbsenceService(absences: absences)
        let viewModel = AbsenceListViewModel(service: service)

        await viewModel.load()

        viewModel.sortOption = .absenceType

        let sorted = viewModel.sortedAbsences

        for pair in zip(sorted, sorted.dropFirst()) {
            let current = pair.0
            let next = pair.1

            let typeComparison = current.absenceType.displayName
                .localizedCaseInsensitiveCompare(
                    next.absenceType.displayName
                )

            XCTAssertTrue(
                typeComparison != .orderedDescending
            )
        }
    }

    func test_sortedAbsences_whenNotLoaded_returnsEmptyArray() async {
        let service = MockAbsenceService()
        let viewModel = AbsenceListViewModel(service: service)

        XCTAssertTrue(viewModel.sortedAbsences.isEmpty)
    }
    
    func test_load_whenConflictRequestsFail_stillLoadsAbsences() async throws {
        let fixtures = try FixtureLoader.loadAbsences()
        
        let service = MockAbsenceService(
            absences: fixtures,
            conflictError: TestError.network
        )

        let viewModel = AbsenceListViewModel(service: service)

        await viewModel.load()

        guard case let .loaded(result) = viewModel.state else {
              return XCTFail("Expected loaded state")
          }

          XCTAssertEqual(result.count, fixtures.count)
          XCTAssertTrue(viewModel.conflicts.isEmpty)
    }
}
