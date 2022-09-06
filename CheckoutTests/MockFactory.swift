//
//  MockFactory.swift
//  CheckoutTests
//
//  Created by Sergiy Kostrykin on 06/09/2022.
//

import Foundation
@testable import Checkout

class MockFactory {
    
    class var validCreditCard: CreditCard {
        CreditCard(cardNumber: "4242424242424242", expireMonth: "01", expireYear: "2029", cvv: "123")
    }

    class var invalidNumberCreditCard: CreditCard {
        CreditCard(cardNumber: "4", expireMonth: "01", expireYear: "2029", cvv: "123")
    }

    class var invalidCVVCreditCard: CreditCard {
        CreditCard(cardNumber: "4242424242424242", expireMonth: "01", expireYear: "2029", cvv: "3")
    }

    class var invalidExpireMonthCreditCard: CreditCard {
        CreditCard(cardNumber: "4", expireMonth: "22", expireYear: "2029", cvv: "123")
    }

    class var invalidExpireYearCreditCard: CreditCard {
        CreditCard(cardNumber: "4", expireMonth: "01", expireYear: "2000", cvv: "123")
    }
}
