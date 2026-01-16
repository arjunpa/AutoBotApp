//
//  JSONLoader.swift
//  AutoBotApp
//
//  Created by Arjun P A on 16/01/26.
//

import Foundation
import AutoBotKit

final class JSONLoader {

    static func loadTest(named name: String) -> TestSpec {
        let bundle = Bundle(for: self.self)
        let url = bundle.url(forResource: name, withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return try! TestSpecDecoder.decode(from: data)
    }
}
