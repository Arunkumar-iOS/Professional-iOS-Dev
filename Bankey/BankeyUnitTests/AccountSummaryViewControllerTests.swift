//
//  AccountSummaryViewControllerTests.swift
//  BankeyUnitTests
//
//  Created by Arunkumar on 23/05/25.
//

import Foundation
import XCTest

@testable import Bankey

class AccountSummaryViewControllerTests: XCTestCase {
    var vc: AccountSummaryViewController!
    var mockManager: MockProfileManager!
    
    class MockProfileManager: ProfileManagable {
        
        var profile: Profile?
        var error: NetworkError?
        
        
        func fetch<T>(url: URL, completion: @escaping (Result<T, NetworkError>) -> Void) {
            if error != nil {
                completion(.failure(error!))
                return
            }
            profile = Profile(id: "1", firstName: "FirstName", lastName: "lastName")
            if let profile = profile as? T {
                completion(.success(profile))
            } else {
                completion(.failure(.parsingError))
            }
        }
        
        
    }
    
    override func setUp() {
        super.setUp()
        vc = AccountSummaryViewController()
        //If you want to call view life cycle event you can call this (e.x) it would trigger viewDidLoad
        // vc.loadViewIfNeeded()
        
        mockManager = MockProfileManager()
        vc.apiCallManager = mockManager
    }
    
    func testSomething() throws {
        
    }
    
    func testAlertForServerError() {
        mockManager.error = .serverError
        
        vc.forceFetchProfile()
        
        XCTAssertEqual("Server Error", NetworkError.serverError.alertContent.title)
        XCTAssertEqual("Ensure you are connected to the internet. Please try again.", NetworkError.serverError.alertContent.message)
    }
    
    func testAlertForParseError() {
        mockManager.error = .parsingError
        
        vc.forceFetchProfile()
        
        XCTAssertEqual("Decoding Error", NetworkError.parsingError.alertContent.title)
        XCTAssertEqual("We could not process your request. Please try again.", NetworkError.parsingError.alertContent.message)
    }
}
