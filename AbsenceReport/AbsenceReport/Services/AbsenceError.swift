//
//  AbsenceError.swift
//  AbsenceReport
//
//  Created by Achintha kahawalage on 2026-08-01.
//

import Foundation

enum AbsenceError: Error {
    case transportFailure(Error)
    case invalidResponse
    case badStatus(Int)
    case decodingFailure(DecodingError)
}

extension AbsenceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .transportFailure:
            return "Unable to connect to the server. Please check your internet connection and try again."

        case .invalidResponse:
            return "The server returned an invalid response."

        case .badStatus(let code):
            return "The server returned an unexpected response (\(code))."

        case .decodingFailure:
            return "The server returned data in an unexpected format."
        }
    }
}
