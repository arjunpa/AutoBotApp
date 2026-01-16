//
//  StepResult.swift
//  AutoBotApp
//
//  Created by Arjun P A on 17/01/26.
//

public struct StepResult {
    public let index: Int
    public let description: String
    public let passed: Bool
    public let error: String?

    public init(index: Int, description: String, passed: Bool, error: String? = nil) {
        self.index = index
        self.description = description
        self.passed = passed
        self.error = error
    }
}
