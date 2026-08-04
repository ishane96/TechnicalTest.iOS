//
//  AbsenceReportApp.swift
//  AbsenceReport
//
//  Created by Achintha kahawalage on 2026-08-01.
//

import SwiftUI

@main
struct AbsenceReportApp: App {
    var body: some Scene {
        WindowGroup {
            AbsenceListView(
                viewModel: AbsenceListViewModel(
                    service: AbsenceService(baseURL: AppEnvironment.baseURL)
                )
            )
        }
    }
}
