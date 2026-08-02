//
//  FixtureLoader.swift
//  AbsenceReportTests
//
//  Created by Achintha Kahawalage on 2026-08-01.
//

import Foundation
@testable import AbsenceReport

final class FixtureLoader {

    enum FixtureLoaderError: Error {
        case fileNotFound(String)
    }

    static func load(_ fileName: String) throws -> Data {
        let bundle = Bundle(for: FixtureLoader.self)

        guard let url = bundle.url(
            forResource: fileName,
            withExtension: "json"
        ) else {
            throw FixtureLoaderError.fileNotFound(fileName)
        }

        return try Data(contentsOf: url)
    }

    static func decode<T: Decodable>(
        _ type: T.Type,
        from filename: String
    ) throws -> T {
        let data = try load(filename)
        return try JSONDecoder.absenceDecoder.decode(T.self, from: data)
    }
    
    static func loadAbsences() throws -> [Absence] {
        try decode([Absence].self, from: "absences_stub")
    }
}
