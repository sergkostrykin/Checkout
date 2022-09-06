//
//  CardScheme.swift
//  Checkout
//
//  Created by Sergiy Kostrykin on 06/09/2022.
//

import UIKit

/// List of the card schemes available.
///
/// - americanExpress
/// - maestro
/// - mastercard
/// - visa
/// - unionPay
enum CardScheme: String, CaseIterable {

    /// American Express
    case americanExpress = "amex"

    /// Mastercard
    case mastercard

    /// Visa
    case visa

    /// Union Pay
    case unionPay = "unionpay"
}

extension CardScheme {
    
    var pattern: String {
        
        switch self {
        case .americanExpress:
            return "^3[47]\\d*$"
        case .mastercard:
            return "^(5[1-5]|222[1-9]|22[3-9]|2[3-6]|27[0-1]|2720)\\d*$"
        case .visa:
            return "^4\\d*$"
        case .unionPay:
            return "^(((620|(621(?!83|88|98|99))|622(?!06|018)|62[3-6]|627[02,06,07]|628(?!0|1)|629[1,2]))\\d*|622018\\d{12})$"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .americanExpress:
            return UIImage(named: "icon-amex")
        case .mastercard:
            return UIImage(named: "icon-master")
        case .visa:
            return UIImage(named: "icon-visa")
        case .unionPay:
            return UIImage(named: "icon-unionpay")
        }
    }
    
    static func scheme(cardNumber: String?) -> CardScheme? {
        for scheme in CardScheme.allCases {
            if cardNumber?.range(of: scheme.pattern, options: .regularExpression, range: nil, locale: nil) != nil {
                return scheme
            }
        }
        return nil
    }
}
