//
//  AbsenceListViewModel.swift
//  AbsenceReport
//
//  Created by Achintha kahawalage on 2026-08-02.
//

import Foundation
import Observation

enum ViewState: Equatable {
    case idle
    case loading
    case loaded([Absence])
    case empty
    case failed(String)
    
    var isLoaded: Bool {
        if case .loaded = self { true } else { false }
    }
}

enum SortOption: CaseIterable, Identifiable {
    case startDateAscending
    case startDateDescending
    case employeeName
    case absenceType
    
    var id: Self { self }
    
    var title: String {
        switch self {
        case .startDateAscending:
            return "Start date (earliest first)"
        case .startDateDescending:
            return "Start date (latest first)"
        case .employeeName:
            return "Employee name"
        case .absenceType:
            return "Absence type"
        }
    }
}

@MainActor
@Observable
final class AbsenceListViewModel {
    
    // MARK: - State
    
    private(set) var state: ViewState = .idle
    private(set) var conflicts: [Int: Bool] = [:]
    
    var sortOption: SortOption = .startDateAscending
    
    // MARK: - Dependencies
    
    private let service: AbsenceServiceProtocol
    
    init(service: AbsenceServiceProtocol) {
        self.service = service
    }
    
    // MARK: - Derived Data
    
    var sortedAbsences: [Absence] {
        guard case let .loaded(absences) = state else {
            return []
        }
        
        switch sortOption {
        case .startDateAscending:
            return absences.sorted { $0.startDate < $1.startDate }
            
        case .startDateDescending:
            return absences.sorted { $0.startDate > $1.startDate }
            
        case .employeeName:
            return absences.sorted { lhs, rhs in
                let nameComparison = lhs.employee.fullName
                    .localizedCaseInsensitiveCompare(rhs.employee.fullName)
                
                if nameComparison == .orderedSame {
                    return lhs.startDate < rhs.startDate
                }
                
                return nameComparison == .orderedAscending
            }
        case .absenceType:
            return absences.sorted { lhs, rhs in
                let typeComparison = lhs.absenceType.displayName
                    .localizedCaseInsensitiveCompare(rhs.absenceType.displayName)
                if typeComparison == .orderedSame {
                    return lhs.employee.fullName.localizedCaseInsensitiveCompare(
                        rhs.employee.fullName
                    ) == .orderedAscending
                }
                return typeComparison == .orderedAscending
            }
        }
    }
    
    // MARK: - Actions
    
    func load() async {
        let previousState = state
        if !state.isLoaded { state = .loading }
        
        do {
            let absences = try await service.fetchAbsences()
            
            if absences.isEmpty {
                state = .empty
            } else {
                state = .loaded(absences)
                
                await loadConflicts(for: absences)
            }
        } catch is CancellationError {
            state = previousState
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
    
    private func loadConflicts(for absences: [Absence]) async {
        let service = self.service
        
        var loadedConflicts: [Int: Bool] = [:]
        
        await withTaskGroup(of: (Int, Bool)?.self) { group in
            for absence in absences {
                let id = absence.id
                
                group.addTask {
                    do {
                        let hasConflict = try await service.fetchConflict(for: id)
                        return (id, hasConflict)
                    } catch {
                        return nil
                    }
                }
            }
            
            for await result in group {
                if let (id, hasConflict) = result {
                    loadedConflicts[id] = hasConflict
                }
            }
        }
        
        conflicts = loadedConflicts
    }
    
    func absences(for employee: Employee) -> [Absence] {
        guard case let .loaded(absences) = state else {
            return []
        }
        
        return absences
            .filter { $0.employee.id == employee.id }
            .sorted { $0.startDate < $1.startDate }
    }
}
