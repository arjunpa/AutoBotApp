//
//  ActionType.swift
//  AutoBotApp
//
//  Created by Arjun P A on 16/01/26.
//

public enum ActionType: String, Codable {
    case click
    case fill
    case clear
    case check
    case verify
}

public struct Target: Codable {
    public let id: String?
    public let `class`: String?
    public let index: Int?
}

public struct Verify: Codable {
    public let type: String
    public let expected: CodableValue?
    public let contains: String?
    public let timeout: Int?
}

public enum CodableValue: Codable {
    case bool(Bool)
    case string(String)
    case number(Int)
    case object([String: CodableValue])

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let b = try? container.decode(Bool.self) { self = .bool(b); return }
        if let i = try? container.decode(Int.self) { self = .number(i); return }
        if let s = try? container.decode(String.self) { self = .string(s); return }
        if let o = try? container.decode([String: CodableValue].self) { self = .object(o); return }
        throw DecodingError.typeMismatch(CodableValue.self, .init(codingPath: decoder.codingPath, debugDescription: "Invalid value"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .bool(let b): try container.encode(b)
        case .number(let i): try container.encode(i)
        case .string(let s): try container.encode(s)
        case .object(let o): try container.encode(o)
        }
    }
}

public struct Step: Codable {
    public let description: String
    public let target: Target?
    public let action: ActionType
    public let value: String?
    public let verify: Verify?
}

public struct TestSpec: Codable {
    public let test_name: String
    public let description: String
    public let steps: [Step]
}
