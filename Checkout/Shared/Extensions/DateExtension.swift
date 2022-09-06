//
//  DateExtension.swift
//  Checkout
//
//  Created by Sergiy Kostrykin on 05/09/2022.
//

import Foundation

extension Date {
        
    static let creditCardDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat =  "MM/yy"
        return formatter
    }()
    
    init?(month: String?, year: String?) {
        guard let month = month, let month = Int(month), let year = year, let year = Int(year) else {
            return nil
        }
        let components = DateComponents(year: year, month: month)
        guard let date = Calendar.current.date(from: components) else {
            return nil
        }
        
        
        self = date.startOfMonth
    }
    
    var startOfMonth: Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components)!
    }


    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        calendar.component(component, from: self)
    }
}
