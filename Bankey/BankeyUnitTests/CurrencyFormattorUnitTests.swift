//
//  CurrencyFormattorUnitTests.swift
//  BankeyUnitTests
//
//  Created by Arunkumar on 19/05/25.
//

import Foundation
import XCTest


@testable import Bankey

final class CurrencyFormattorUnitTests: XCTestCase {
    
    
    override func setUp() {
        super.setUp()
    }
    
    func testCurrencyFormatter() throws {
    
        // Given
        let amount: Double = 123456.78
        
        // When
        let result = CurrencyFormatter.formattedBalanceWithSuperscript(from: amount).string
        
        print(result)
        
        // Then
        XCTAssertEqual(result, "$1,23,45678")
        XCTAssertTrue(result.contains("$1,23"))
    }
    
    func testAttributedStringFormat() throws {
        
        //Know the currency symbol
        let locale = Locale.current
        print("Currency symbol = \(locale.currencySymbol ?? "$")")
        
        let result = CurrencyFormatter.makeBalanceAttributed(dollars: "111", cents: "11")
        
        XCTAssertEqual(result.string, "$11111")
        
    }
   
}
