//
//  Untitled.swift
//  AbsenceReport
//
//  Created by Achintha kahawalage on 2026-08-01.
//

import Foundation

final class FixtureLoader {
    enum FixtureLoaderError: Error {
        case fileNotFound(String)
    }
    static func load(_ fileName: String) throws -> Data {
        let bundle = Bundle(for: FixtureLoader.self)
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            throw FixtureLoaderError.fileNotFound(fileName)
        }
        return try Data(contentsOf: url)
    }
    static func decode<T: Decodable>(
        _ type: T.Type,
        from filename: String
    ) throws -> T {
        let data = try load(filename)
        return try decoder.decode(T.self, from: data)
    }
    static let decoder: JSONDecoder = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            guard let date = formatter.date(from: dateString) else {
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Invalid ISO8601 date: \(dateString)"
                )
            }
            return date
        }
        return decoder
    }()
}
