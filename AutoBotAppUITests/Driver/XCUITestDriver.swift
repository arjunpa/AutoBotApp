//
//  XCUITestDriver.swift
//  AutoBotApp
//
//  Created by Arjun P A on 16/01/26.
//

import XCTest
import AutoBotKit

final class XCUITestDriver: BotDriver {

    typealias Element = XCUIElement
    private let app: XCUIApplication

    init(app: XCUIApplication) {
        self.app = app
    }

    // MARK: - Find

    func find(by target: Target) async -> XCUIElement? {
        if let id = target.id {
            let el = await app.descendants(matching: .any)[id]
            return await el.exists ? el : nil
        }
        if let cls = target.class, let index = target.index {
            let type = mapClass(cls)
            let el = await app.descendants(matching: type).element(boundBy: index)
            return await el.exists ? el : nil
        }
        return nil
    }

    // MARK: - Actions

    func tap(_ element: XCUIElement) async {
        await element.tap()
        await settle()
    }

    func type(_ element: XCUIElement, text: String) async {

        // Request focus
        await element.tap()

        // Wait for keyboard (NOT keyboard focus)
        guard await waitForKeyboard() else {
            XCTFail("Keyboard did not appear — cannot type")
            return
        }

        // Type safely
        await element.typeText(text)

        // Dismiss keyboard immediately
        await dismissKeyboard()

        // Allow UI to settle
        await settle()
    }


    func clear(_ element: XCUIElement) async {

        await element.tap()

        guard await waitForKeyboard() else { return }

        let delete = String(
            repeating: XCUIKeyboardKey.delete.rawValue,
            count: 50
        )
        await element.typeText(delete)

        await dismissKeyboard()
        await settle()
    }


    func longPress(_ element: XCUIElement) async {
        await element.press(forDuration: 1.0)
        await settle()
    }

    // MARK: - State

    func exists(_ element: XCUIElement) async -> Bool { await element.exists }
    func isHittable(_ element: XCUIElement) async -> Bool { await element.isHittable }
    func frame(_ element: XCUIElement) async -> CGRect { await element.frame }

    // MARK: - System

    func isKeyboardVisible() -> Bool {
        app.keyboards.count > 0
    }

    func findToast(containing text: String, timeout: TimeInterval) async -> Bool {
        let predicate = NSPredicate(format: "label CONTAINS %@", text)
        let el = await app.staticTexts.element(matching: predicate)
        return await el.waitForExistence(timeout: timeout)
    }

    func allElements() async -> [XCUIElement] {
        await app.descendants(matching: .any).allElementsBoundByIndex
    }

    // MARK: - Helpers

    private func waitForKeyboard(
        timeout: TimeInterval = 5.0
    ) async -> Bool {

        let deadline = Date().addingTimeInterval(timeout)

        while Date() < deadline {

            // ✅ synchronous check
            if isKeyboardVisible() {
                return true
            }

            // ✅ async pause to yield execution
            try? await Task.sleep(nanoseconds: 50_000_000) // 50ms
        }

        return false
    }

    private func dismissKeyboard() async {
        if await app.keyboards.count > 0 {
            await app.keyboards.buttons["Return"].firstMatch.tap()
        }
    }

    private func settle() async {
        try? await Task.sleep(nanoseconds: 100_000_000) // 100ms UI settle
    }

    private func mapClass(_ name: String) -> XCUIElement.ElementType {
        switch name.lowercased() {
        case "radiobutton": return .button
        default: return .any
        }
    }
}
