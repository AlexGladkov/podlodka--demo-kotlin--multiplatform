//
//  Data+Codable.swift
//  QuestGo
//
//  Created by Алексей Гладков on 18.08.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import Foundation

// Available only in this file
extension Data {

    /// Makes data convertion to Decodable
    ///
    /// - Returns: Decodable Generic Type
    func decode<T>() -> T? where T: Decodable {
        do {
            return try JSONDecoder().decode(T.self, from: self)
        } catch {
            print("Encoding failed with \(error)")
            return nil
        }
    }

    // Makes error convertion to Decodable
    ///
    /// - Returns: Decodable Generic Type
    func decodeError<T>() -> T? where T: Decodable {
        return try? JSONDecoder().decode(T.self, from: self)
    }
}
