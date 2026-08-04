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
                    service: Self.service
                )
            )
        }
    }
    private static var service: AbsenceServiceProtocol {
           #if DEBUG
           if ProcessInfo.processInfo.arguments.contains("-uiTesting") {
               return StubAbsenceService()
           }
           #endif
           return AbsenceService(baseURL: AppEnvironment.baseURL)
       }
}
