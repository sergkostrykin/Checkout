//
//  CreditCardTests.swift
//  CheckoutTests
//
//  Created by Sergiy Kostrykin on 06/09/2022.
//

import XCTest
@testable import Checkout

class CreditCardTests: XCTestCase {

    func testValidCreditCard() {
        let creditCard = MockFactory.validCreditCard
        if creditCard.validate() != nil {
            XCTFail()
        }
    }
    
    func testInvalidCreditCardNumber() {
        let creditCard = MockFactory.invalidNumberCreditCard
        if creditCard.validate() == nil {
            XCTFail()
        }
    }
    
    func testInvalidCreditCardExpireYear() {
        let creditCard = MockFactory.invalidExpireYearCreditCard
        if creditCard.validate() == nil {
            XCTFail()
        }
    }
    
    func testInvalidCreditCardExpireMonth() {
        let creditCard = MockFactory.invalidExpireMonthCreditCard
        if creditCard.validate() == nil {
            XCTFail()
        }
    }

    
    func testInvalidCreditCardCVV() {
        let creditCard = MockFactory.invalidCVVCreditCard
        if creditCard.validate() == nil {
            XCTFail()
        }
    }
}
