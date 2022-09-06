//
//  CreditCard.swift
//  Checkout
//
//  Created by Sergiy Kostrykin on 01/09/2022.
//

import Foundation

struct CreditCard {
    var cardNumber: String?
    var expireMonth: String?
    var expireYear: String?
    var cvv: String?
    var scheme: CardScheme?
}

extension CreditCard {
    
    func validate() -> String? {
        guard let cardNumber = cardNumber, cardNumber.count == 16 else {
            return "Please enter a valid card number."
        }
        
        guard let date = Date(month: expireMonth, year: expireYear), date >= Date().startOfMonth  else {
            return "Please enter valid expire date."
        }
                
        guard let cvv = cvv, cvv.count == 3 else {
            return "Please enter a valid CVV."
        }
        return nil
    }
    
}
