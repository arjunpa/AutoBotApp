//
//  BotDriver.swift
//  AutoBotApp
//
//  Created by Arjun P A on 16/01/26.
//

import CoreGraphics
import Foundation

public protocol BotDriver {
    associatedtype Element

    // Finding
    func find(by target: Target) async -> Element?

    // Actions
    func tap(_ element: Element) async
    func type(_ element: Element, text: String) async
    func clear(_ element: Element) async
    func longPress(_ element: Element) async

    // State
    func exists(_ element: Element) async -> Bool
    func isHittable(_ element: Element) async -> Bool
    func frame(_ element: Element) async -> CGRect

    // System
    func isKeyboardVisible() -> Bool
    func findToast(containing text: String, timeout: TimeInterval) async -> Bool

    // Crawler
    func allElements() async -> [Element]
}
