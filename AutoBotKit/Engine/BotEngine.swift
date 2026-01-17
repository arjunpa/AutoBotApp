//
//  BotEngine.swift
//  AutoBotApp
//
//  Created by Arjun P A on 16/01/26.
//

import Foundation
public final class BotEngine<Driver: BotDriver> {

    private let actionEngine: ActionEngine<Driver>
    private let logger = BotLogger()
    private var results: [StepResult] = []

    public init(driver: Driver) {
        self.actionEngine = ActionEngine(driver: driver)
    }

    public func run(test: TestSpec) async {

        results.removeAll()

        logger.startTest(
            name: test.test_name,
            description: test.description
        )

        for (index, step) in test.steps.enumerated() {

            logger.step(index, step.description)
            logger.target(step.target)
            logger.action(step.action, value: step.value)

            if step.action == .verify, let verify = step.verify {
                logger.verify(verify)
            }

            do {
                try await actionEngine.execute(step: step)

                logger.success()
                results.append(
                    StepResult(
                        index: index,
                        description: step.description,
                        passed: true
                    )
                )

            } catch {

                logger.failure(error.localizedDescription)
                results.append(
                    StepResult(
                        index: index,
                        description: step.description,
                        passed: false,
                        error: error.localizedDescription
                    )
                )
            }
        }

        let passed = results.filter { $0.passed }.count
        logger.endTest(passed: passed, total: results.count)
    }
}
