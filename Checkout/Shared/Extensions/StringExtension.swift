//
//  StringExtension.swift
//  Checkout
//
//  Created by Sergiy Kostrykin on 05/09/2022.
//

import Foundation

extension String {
    
    static var creditCardNumberMask: String {
        "XXXX XXXX XXXX XXXX"
    }

    static var creditCardExpMask: String {
        "XX/XX"
    }

    var digitsOnly: String {
        components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
    
    var creditCardExpireDate: Date? {
        Date.creditCardDateFormatter.date(from: self)
    }

    func formatDigits(mask: String) -> String {
        let numbers = self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
}
