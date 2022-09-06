//
//  PayRequest.swift
//  Checkout
//
//  Created by Sergiy Kostrykin on 01/09/2022.
//

import Foundation

struct PayRequest: Codable {
    
    let cardNumber: String?
    let expiryYear: String?
    let expiryMonth: String?
    let cvv: String?
    let successUrl: String?
    let failureUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case cardNumber = "number"
        case expiryYear = "expiry_year"
        case expiryMonth = "expiry_month"
        case cvv
        case successUrl = "success_url"
        case failureUrl = "failure_url"
    }
}

extension PayRequest {
    
    init(creditCard: CreditCard) {
        self.cardNumber = creditCard.cardNumber
        self.expiryMonth = creditCard.expireMonth
        self.expiryYear = creditCard.expireYear
        self.cvv = creditCard.cvv
        self.successUrl = Link.success.rawValue
        self.failureUrl = Link.failure.rawValue
    }
}
