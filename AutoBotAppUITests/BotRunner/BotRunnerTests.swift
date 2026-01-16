//
//  BotRunnerTests.swift
//  AutoBotApp
//
//  Created by Arjun P A on 16/01/26.
//

import XCTest
import AutoBotKit

final class BotRunnerTests: XCTestCase {

    func testSequentialCrawl() {
        let app = XCUIApplication()
        app.launch()

        let driver = XCUITestDriver(app: app)
        let crawler = SequentialCrawler(driver: driver)

        crawler.crawl()
    }

    func testHoneypotBotDetection() {
        let app = XCUIApplication()
        app.launch()

        let spec = JSONLoader.loadTest(named: "honeypot")
        let driver = XCUITestDriver(app: app)
        let engine = BotEngine(driver: driver)

        engine.run(test: spec)
    }
}
