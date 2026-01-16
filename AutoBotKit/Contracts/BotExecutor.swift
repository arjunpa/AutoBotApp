//
//  BotExecutor.swift
//  AutoBotApp
//
//  Created by Arjun P A on 16/01/26.
//

public protocol BotExecutor {
    func click(target: Target)
    func fill(target: Target, value: String)
    func clear(target: Target)
    func check(target: Target)
    func verify(target: Target?, verify: Verify)
}
