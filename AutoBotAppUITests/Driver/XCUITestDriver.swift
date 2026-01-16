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

    func find(by target: Target) -> XCUIElement? {
        if let id = target.id {
            let el = app.descendants(matching: .any)[id]
            return el.exists ? el : nil
        }
        if let cls = target.class, let index = target.index {
            let type = mapClass(cls)
            let el = app.descendants(matching: type).element(boundBy: index)
            return el.exists ? el : nil
        }
        return nil
    }

    func tap(_ element: XCUIElement) { element.tap() }
    func type(_ element: XCUIElement, text: String) { element.tap(); element.typeText(text) }
    func clear(_ element: XCUIElement) {
        element.tap()
        let delete = String(repeating: XCUIKeyboardKey.delete.rawValue, count: 50)
        element.typeText(delete)
    }
    func longPress(_ element: XCUIElement) { element.press(forDuration: 1.0) }

    func exists(_ element: XCUIElement) -> Bool { element.exists }
    func isHittable(_ element: XCUIElement) -> Bool { element.isHittable }
    func hasFocus(_ element: XCUIElement) -> Bool { element.hasFocus }
    func frame(_ element: XCUIElement) -> CGRect { element.frame }

    func isKeyboardVisible() -> Bool { app.keyboards.count > 0 }

    func findToast(containing text: String, timeout: TimeInterval) -> Bool {
        let predicate = NSPredicate(format: "label CONTAINS %@", text)
        let el = app.staticTexts.element(matching: predicate)
        return el.waitForExistence(timeout: timeout)
    }

    func allElements() -> [XCUIElement] {
        app.descendants(matching: .any).allElementsBoundByIndex
    }

    private func mapClass(_ name: String) -> XCUIElement.ElementType {
        switch name.lowercased() {
        case "radiobutton": return .button
        default: return .any
        }
    }
}
