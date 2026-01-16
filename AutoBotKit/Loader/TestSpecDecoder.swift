//
//  TestSpecDecoder.swift
//  AutoBotApp
//
//  Created by Arjun P A on 16/01/26.
//

import Foundation

public enum TestSpecDecoder {
    public static func decode(from data: Data) throws -> TestSpec {
        let decoder = JSONDecoder()
        return try decoder.decode(TestSpec.self, from: data)
    }
}
