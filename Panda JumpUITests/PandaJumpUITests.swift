//
//  PandaJumpUITests.swift
//  Panda JumpUITests
//
//  Plays through the app in the simulator: start a game, jump, die, then visit the shop.
//  The game itself is SpriteKit, so its buttons are tapped by screen position.
//

import XCTest

final class PandaJumpUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["-UITesting"]
        app.launch()
    }

    /// Taps a point given as fractions of the screen, measured from the top-left.
    private func tap(x: CGFloat, y: CGFloat) {
        app.coordinate(withNormalizedOffset: CGVector(dx: x, dy: y)).tap()
    }

    private func screenshot(_ name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    private func assertStillRunning(_ step: String) {
        XCTAssertEqual(app.state, .runningForeground, "App is no longer running after: \(step)")
    }

    /// The game-over buttons sit 42.7% up from the bottom, 85pt either side of centre.
    private func tapGameOverButton(offset: CGFloat) {
        let width = app.windows.firstMatch.frame.width
        tap(x: 0.5 + offset * 85 / width, y: 1 - 0.427)
    }

    func testPlayDieAndVisitShop() {
        sleep(3)
        screenshot("1 - Title screen")
        assertStillRunning("launch")

        // Start the game and jump a few times. Taps are kept high on the screen,
        // away from where the game-over buttons appear.
        for _ in 0..<6 {
            tap(x: 0.5, y: 0.3)
            usleep(700_000)
        }
        screenshot("2 - Playing")
        assertStillRunning("playing")

        // Stop jumping; the next boulder ends the game.
        sleep(8)
        screenshot("3 - Game over")
        assertStillRunning("game over")

        // Customize button (left of centre).
        tapGameOverButton(offset: -1)
        let table = app.tables.firstMatch
        XCTAssertTrue(table.waitForExistence(timeout: 5), "Shop did not open")
        sleep(1)
        screenshot("4 - Shop")
        XCTAssertEqual(table.cells.count, 5, "Expected 5 skins in the shop")

        // Every skin that isn't owned must show its price, including the last one.
        table.swipeUp()
        let devCell = table.cells.element(boundBy: 4)
        XCTAssertTrue(devCell.staticTexts["100000"].exists, "Dev skin price is missing")

        // Open a skin's detail screen and try to buy it.
        table.swipeDown()
        table.cells.element(boundBy: 1).tap()
        let back = app.buttons["Back"]
        XCTAssertTrue(back.waitForExistence(timeout: 5), "Skin detail did not open")
        sleep(1)
        screenshot("5 - Skin detail")

        let purchase = app.buttons.matching(NSPredicate(format: "label IN %@", ["30$", "Equip", "Equipped"])).firstMatch
        XCTAssertTrue(purchase.exists, "Purchase button not found")
        purchase.tap()
        let alertOK = app.alerts.buttons["OK"]
        if alertOK.waitForExistence(timeout: 2) {
            screenshot("6 - Not enough coins")
            alertOK.tap()
        }
        assertStillRunning("purchase")

        back.tap()
        XCTAssertTrue(app.buttons["Close"].waitForExistence(timeout: 5), "Did not return to the shop")
        app.buttons["Close"].tap()
        XCTAssertTrue(table.waitForNonExistence(timeout: 5), "Shop did not close")

        // Play again (right of centre).
        sleep(1)
        tapGameOverButton(offset: 1)
        sleep(2)
        tap(x: 0.5, y: 0.3)
        sleep(1)
        screenshot("7 - New game")
        assertStillRunning("play again")
    }
}
