//
//  SequentialCrawler.swift
//  AutoBotApp
//
//  Created by Arjun P A on 16/01/26.
//

import Foundation
import CoreGraphics

public class SequentialCrawler<Driver: BotDriver> {
    
    private let driver: Driver
    
    private var processed = Set<String>()
    
    public init(driver: Driver) {
        self.driver = driver
    }
    
    public func crawl() {
        let elements = driver.allElements()
        
        let sorted = elements.sorted {
            let f1 = driver.frame($0)
            let f2 = driver.frame($1)
            
            
            if abs(f1.minX - f2.minY) < 5 {
                return f1.minX < f2.minX
            }
            
            return f1.minY < f2.minY
        }
        
        for el in sorted {
            let sig = signature(for: el)
            if processed.contains(sig) { continue }
            processed.insert(sig)
        }
    }
    
    private func signature(for el: Driver.Element) -> String {
        let f = driver.frame(el)
        return "\(f.origin.x)_\(f.origin.y)_\(f.width)_\(f.height)"
    }
    
    private func interact(with el: Driver.Element) {
        if driver.isHittable(el) {
            driver.tap(el)
        }
    }
}
