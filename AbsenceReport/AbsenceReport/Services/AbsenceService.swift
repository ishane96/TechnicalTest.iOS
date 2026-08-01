//
//  AbsenceService.swift
//  AbsenceReport
//
//  Created by Achintha kahawalage on 2026-08-01.
//

import Foundation

protocol AbsenceServiceProtocol: Sendable {
    func fetchAbsences() async throws -> [Absence]
    func fetchConflict(for absenceID: Int) async throws -> Bool
}

struct AbsenceService: AbsenceServiceProtocol {

    private let session: URLSession
    private let baseURL: URL

    init(baseURL: URL, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }
    func fetchAbsences() async throws -> [Absence] {
        try await fetch(
            [Absence].self,
            from: baseURL.appending(path: "absences")
        )
    }

    func fetchConflict(for absenceID: Int) async throws -> Bool {
        let conflictURL = baseURL.appending(path: "conflict")
            .appending(path: "\(absenceID)")

        let response = try await fetch(ConflictResponse.self, from: conflictURL)
        return response.conflicts
    }

    private func fetch<T: Decodable>(
        _ type: T.Type,
        from url: URL
    ) async throws -> T {

        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await session.data(from: url)
        } catch {
            throw AbsenceError.transportFailure(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw AbsenceError.invalidResponse
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            throw AbsenceError.badStatus(httpResponse.statusCode)
        }

        do {
            return try JSONDecoder.absenceDecoder.decode(
                T.self,
                from: data
            )
        } catch let error as DecodingError {
            throw AbsenceError.decodingFailure(error)
        }
    }
}
