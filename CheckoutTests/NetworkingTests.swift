//
//  NetworkingTests.swift
//  CheckoutTests
//
//  Created by Sergiy Kostrykin on 06/09/2022.
//

import XCTest
@testable import Checkout

class NetworkingTests: XCTestCase {

    func testValidCreditCardRequest() {
        let expectation = self.expectation(description: "Credit card payment 3ds expectation")
        let creditCard = MockFactory.validCreditCard
        NetworkingService.pay(creditCard: creditCard) { result, error in
            if error != nil {
                XCTFail()
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 10)
    }
    
    func testInvalidCreditCardNumberRequest() {
        let expectation = self.expectation(description: "Credit card payment 3ds expectation")
        let creditCard = MockFactory.invalidNumberCreditCard
        NetworkingService.pay(creditCard: creditCard) { result, error in
            if error == nil {
                XCTFail()
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 10)
    }

    func testInvalidCreditCardCVVRequest() {
        let expectation = self.expectation(description: "Credit card payment 3ds expectation")
        let creditCard = MockFactory.invalidCVVCreditCard
        NetworkingService.pay(creditCard: creditCard) { result, error in
            if error == nil {
                XCTFail()
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 10)
    }
    
    func testInvalidCreditCardExpireYearRequest() {
        let expectation = self.expectation(description: "Credit card payment 3ds expectation")
        let creditCard = MockFactory.invalidExpireYearCreditCard
        NetworkingService.pay(creditCard: creditCard) { result, error in
            if error == nil {
                XCTFail()
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 10)
    }

    func testInvalidCreditCardExpireMonthRequest() {
        let expectation = self.expectation(description: "Credit card payment 3ds expectation")
        let creditCard = MockFactory.invalidExpireMonthCreditCard
        NetworkingService.pay(creditCard: creditCard) { result, error in
            if error == nil {
                XCTFail()
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 10)
    }
}
