//
//  SequentialCrawler.swift
//  AutoBotApp
//
//  Created by Arjun P A on 16/01/26.
//

import Foundation
import CoreGraphics

public final class SequentialCrawler<Driver: BotDriver> {

    private let driver: Driver
    private let logger = BotLogger()
    private var processed = Set<String>()

    public init(driver: Driver) {
        self.driver = driver
    }

    public func crawl(maxSteps: Int = 100) async {

        logger.startTest(
            name: "Sequential Crawl",
            description: "Autonomous UI exploration"
        )

        let elements = await driver.allElements()

        // ✅ Precompute frames asynchronously
        var framedElements: [(element: Driver.Element, frame: CGRect)] = []
        framedElements.reserveCapacity(elements.count)

        for element in elements {
            let frame = await driver.frame(element)
            framedElements.append((element, frame))
        }

        // ✅ Sort synchronously (NO async here)
        let sorted = framedElements.sorted {
            if abs($0.frame.minY - $1.frame.minY) < 5 {
                return $0.frame.minX < $1.frame.minX
            }
            return $0.frame.minY < $1.frame.minY
        }

        var stepIndex = 0

        for (element, frame) in sorted {
            if stepIndex >= maxSteps { break }

            let signature = "\(frame.origin.x)_\(frame.origin.y)_\(frame.width)_\(frame.height)"
            if processed.contains(signature) { continue }
            processed.insert(signature)

            logger.step(stepIndex, "Crawler tap")

            await driver.tap(element)
            logger.success()

            stepIndex += 1
        }

        logger.endTest(passed: stepIndex, total: stepIndex)
    }
}
