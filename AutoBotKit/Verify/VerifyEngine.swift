//
//  VerifyEngine.swift
//  AutoBotApp
//
//  Created by Arjun P A on 16/01/26.
//

import CoreGraphics
import Foundation

public final class VerifyEngine<Driver: BotDriver> {

    private let driver: Driver

    public init(driver: Driver) {
        self.driver = driver
    }

    public func verify(target: Target?, verify: Verify) -> Bool {

        switch verify.type {

        case "exists":
            guard let el = driver.find(by: target!) else { return false }
            return driver.exists(el) == bool(verify.expected)

        case "clickable":
            guard let el = driver.find(by: target!) else { return false }
            return driver.isHittable(el) == bool(verify.expected)

        case "focusable":
            guard let el = driver.find(by: target!) else { return false }
            return driver.hasFocus(el) == bool(verify.expected)

        case "size":
            guard let el = driver.find(by: target!) else { return false }
            let frame = driver.frame(el)
            let obj = object(verify.expected)
            return Int(frame.width) == obj["width"] && Int(frame.height) == obj["height"]

        case "keyboard_opens":
            return driver.isKeyboardVisible() == bool(verify.expected)

        case "toast":
            return driver.findToast(containing: verify.contains!, timeout: TimeInterval(verify.timeout ?? 5))

        default:
            return false
        }
    }

    // helpers
    private func bool(_ v: CodableValue?) -> Bool {
        if case .bool(let b)? = v { return b }
        return false
    }

    private func object(_ v: CodableValue?) -> [String: Int] {
        if case .object(let o)? = v {
            var result: [String: Int] = [:]
            for (k, v) in o {
                if case .number(let n) = v { result[k] = n }
            }
            return result
        }
        return [:]
    }
}
