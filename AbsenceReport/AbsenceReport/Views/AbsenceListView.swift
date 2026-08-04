//
//  AbsenceListView.swift
//  AbsenceReport
//
//  Created by Achintha kahawalage on 2026-08-01.
//

import SwiftUI

struct AbsenceListView: View {
    
    @State private var viewModel: AbsenceListViewModel
    
    init(viewModel: AbsenceListViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Absences")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            Picker("Sort", selection: $viewModel.sortOption) {
                                ForEach(SortOption.allCases) { option in
                                    Text(option.title)
                                        .tag(option)
                                }
                            }
                        } label: {
                            Label("Sort", systemImage: "arrow.up.arrow.down")
                                .accessibilityIdentifier("sortButton")
                        }
                    }
                }
                .task {
                    await viewModel.load()
                }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
            
        case .idle, .loading:
            ProgressView()
            
        case .loaded:
            List(viewModel.sortedAbsences) { absence in
                NavigationLink {
                    EmployeeAbsencesView(
                        employee: absence.employee,
                        absences: viewModel.absences(for: absence.employee),
                        conflicts: viewModel.conflicts
                    )
                } label: {
                    AbsenceRow(
                        absence: absence,
                        hasConflict: viewModel.conflicts[absence.id] ?? false
                    )
                }
                .accessibilityIdentifier("absenceRow_\(absence.id)")
            }
            .refreshable {
                await viewModel.load()
            }
            .accessibilityIdentifier("absenceList")
            
        case .empty:
            ContentUnavailableView(
                "No absences",
                systemImage: "calendar.badge.exclamation",
                description: Text("There are no absence records.")
            )
            
        case .failed(let message):
            ContentUnavailableView {
                Label("Unable to load", systemImage: "exclamationmark.triangle")
            } description: {
                Text(message)
            } actions: {
                Button("Retry") {
                    Task {
                        await viewModel.load()
                    }
                }
            }
        }
    }
}
