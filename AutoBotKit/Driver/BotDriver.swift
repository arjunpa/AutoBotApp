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
    
    func find(by target: Target) -> Element?
    func tap(_ element: Element)
    func type(_ element: Element, text: String)
    func clear(_ element: Element)
    func longPress(_ element: Element)
    func exists(_ element: Element) -> Bool
    func isHittable(_ element: Element) -> Bool
    func hasFocus(_ element: Element) -> Bool
    func frame(_ element: Element) -> CGRect
    
    func isKeyboardVisible() -> Bool
    func findToast(containing text: String, timeout: TimeInterval) -> Bool
    
    func allElements() -> [Element]
}
