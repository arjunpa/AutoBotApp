//
//  BotLogger.swift
//  AutoBotApp
//
//  Created by Arjun P A on 17/01/26.
//

public final class BotLogger {

    public enum Level: String {
        case info = "INFO"
        case step = "STEP"
        case action = "ACTION"
        case verify = "VERIFY"
        case success = "✓"
        case failure = "✗"
    }

    public init() {}

    // MARK: - Session

    public func startTest(name: String, description: String) {
        print("""
        ==============================
        TEST: \(name)
        ==============================
        \(description)

        """)
    }

    public func endTest(passed: Int, total: Int) {
        let status = passed == total ? "PASSED" : "FAILED"
        print("""
        ==============================
        RESULT: \(status) (\(passed)/\(total))
        ==============================
        """)
    }

    // MARK: - Step

    public func step(_ index: Int, _ description: String) {
        print("""
        [STEP \(index)] \(description)
        """)
    }

    // MARK: - Target

    public func target(_ target: Target?) {
        guard let target else { return }
        var parts: [String] = []
        if let id = target.id { parts.append("id=\(id)") }
        if let cls = target.class { parts.append("class=\(cls)") }
        if let idx = target.index { parts.append("index=\(idx)") }

        print("Target: " + parts.joined(separator: ", "))
    }

    // MARK: - Action

    public func action(_ action: ActionType, value: String? = nil) {
        if let value {
            print("Action: \(action.rawValue) value=\"\(value)\"")
        } else {
            print("Action: \(action.rawValue)")
        }
    }

    // MARK: - Verify

    public func verify(_ verify: Verify) {
        if let expected = verify.expected {
            print("Verify: \(verify.type) == \(expected)")
        } else {
            print("Verify: \(verify.type)")
        }
    }

    // MARK: - Results

    public func success() {
        print("✓ SUCCESS\n")
    }

    public func failure(_ reason: String) {
        print("✗ FAILURE: \(reason)\n")
    }
}
