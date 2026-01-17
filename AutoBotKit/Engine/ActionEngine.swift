//
//  ActionEngine.swift
//  AutoBotApp
//
//  Created by Arjun P A on 16/01/26.
//

import Foundation

public enum BotError: Error, LocalizedError {
    case elementNotFound
    case verificationFailed(String)

    public var errorDescription: String? {
        switch self {
        case .elementNotFound:
            return "Element not found"
        case .verificationFailed(let msg):
            return msg
        }
    }
}

public final class ActionEngine<Driver: BotDriver> {

    private let driver: Driver
    private let verifier: VerifyEngine<Driver>

    public init(driver: Driver) {
        self.driver = driver
        self.verifier = VerifyEngine(driver: driver)
    }

    public func execute(step: Step) async throws {

        switch step.action {

        case .click:
            guard let el = await driver.find(by: step.target!) else {
                throw BotError.elementNotFound
            }
            await driver.tap(el)

        case .fill:
            guard let el = await driver.find(by: step.target!) else {
                throw BotError.elementNotFound
            }
            await driver.type(el, text: step.value ?? "")

        case .clear:
            guard let el = await driver.find(by: step.target!) else {
                throw BotError.elementNotFound
            }
            await driver.clear(el)

        case .check:
            guard let el = await driver.find(by: step.target!) else {
                throw BotError.elementNotFound
            }
            await driver.tap(el)

        case .verify:
            let ok = await verifier.verify(target: step.target, verify: step.verify!)
            if !ok {
                throw BotError.verificationFailed(step.verify!.type)
            }
        }
    }
}
