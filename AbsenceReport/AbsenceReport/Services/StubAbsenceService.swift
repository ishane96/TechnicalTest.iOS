//
//  StubAbsenceService.swift
//  AbsenceReport
//
//  Created by Achintha kahawalage on 2026-08-04.
//

#if DEBUG

import Foundation

final class StubAbsenceService: AbsenceServiceProtocol {
    
    func fetchAbsences() async throws -> [Absence] {
        let data = Data(Self.json.utf8)
        
        return try JSONDecoder.absenceDecoder.decode(
            [Absence].self,
            from: data
        )
    }
    
    func fetchConflict(for absenceID: Int) async throws -> Bool {
        absenceID == 1
    }
    
    private static let json = """
    [
        {
            "id": 1,
            "startDate": "2022-05-28T04:39:06.470Z",
            "days": 9,
            "absenceType": "SICKNESS",
            "approved": true,
            "employee": {
                "firstName": "Alexi",
                "lastName": "Schramm",
                "id": "employee-1"
            }
        },
        {
            "id": 2,
            "startDate": "2022-06-15T09:00:00.000Z",
            "days": 3,
            "absenceType": "ANNUAL_LEAVE",
            "approved": false,
            "employee": {
                "firstName": "Alexi",
                "lastName": "Schramm",
                "id": "employee-1"
            }
        },
        {
            "id": 3,
            "startDate": "2022-07-10T10:00:00.000Z",
            "days": 5,
            "absenceType": "MEDICAL",
            "approved": true,
            "employee": {
                "firstName": "Rahaf",
                "lastName": "Deckard",
                "id": "employee-2"
            }
        },
        {
            "id": 4,
            "startDate": "2022-08-01T08:30:00.000Z",
            "days": 2,
            "absenceType": "ANNUAL_LEAVE",
            "approved": true,
            "employee": {
                "firstName": "Zoe",
                "lastName": "Smith",
                "id": "employee-3"
            }
        }
    ]
    """
}

#endif
