//
//  JSONDecoder+Absence.swift
//  AbsenceReport
//
//  Created by Achintha kahawalage on 2026-08-01.
//

import Foundation

extension JSONDecoder {

    static let absenceDecoder: JSONDecoder = {
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
