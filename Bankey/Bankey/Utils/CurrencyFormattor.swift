//
//  CurrencyFormattor.swift
//  Bankey
//
//  Created by Arunkumar on 19/05/25.
//

import UIKit

extension Decimal {
    var doubleValue: Double {
        return NSDecimalNumber(decimal:self).doubleValue
    }
}


struct CurrencyFormatter {
    
    static func formattedBalanceWithSuperscript(from amount: Double) -> NSAttributedString {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.currencySymbol = "" // We'll add "$" manually
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2

        guard let formattedString = numberFormatter.string(from: NSNumber(value: amount)) else {
            return NSAttributedString(string: "$ 0.00")
        }

        let parts = formattedString.components(separatedBy: ".")
        let dollars = parts[0]
        let cents = parts.count > 1 ? parts[1] : "00"

        return makeBalanceAttributed(dollars: dollars, cents: cents)
    }
    
     static func makeBalanceAttributed(dollars: String, cents: String) -> NSMutableAttributedString {
        let dollarSignAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.preferredFont(forTextStyle: .callout), .baselineOffset: 8]
        let dollarAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.preferredFont(forTextStyle: .title3)]
        let centAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.preferredFont(forTextStyle: .callout), .baselineOffset: 8]
        
        let rootString = NSMutableAttributedString(string: "$", attributes: dollarSignAttributes)
        let dollarString = NSAttributedString(string: dollars, attributes: dollarAttributes)
        let centString = NSAttributedString(string: cents, attributes: centAttributes)
        
        rootString.append(dollarString)
        rootString.append(centString)
        
        return rootString
    }
}
