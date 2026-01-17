//
//  BotRunnerTests.swift
//  AutoBotApp
//
//  Created by Arjun P A on 16/01/26.
//

import XCTest
import AutoBotKit

final class BotRunnerTests: XCTestCase {

    func testSequentialCrawl() async {
        let app = await XCUIApplication()
        await app.launch()

        let driver = XCUITestDriver(app: app)
        let crawler = SequentialCrawler(driver: driver)

        await crawler.crawl()
    }

    func testHoneypotBotDetection() async {
        let app = await XCUIApplication()
        await app.launch()

        let spec = JSONLoader.loadTest(named: "honeypot")
        let driver = XCUITestDriver(app: app)
        let engine = BotEngine(driver: driver)

        await engine.run(test: spec)
    }
}
