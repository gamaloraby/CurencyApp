//
//  ServiceTest.swift
//  CurrencyTests
//
//  Created by gamal oraby on 03/06/2023.
//

import XCTest

@testable import Currency
class ServiceTest: XCTestCase {
    
    let service: MainService!
    
    override func setUpWithError() throws {
        service = MainService()
    }
    
    func testGetRates() {
       
        let expectation = XCTestExpectation(description: "service success")
        var error: Error?
        var ratesResponse: RatesResponse?
        service.getRates { (response, error) in
            error = error
            ratesResponse = response
            exception.fulfill()
        }
        waitForExpectations(timeout: 3)
        XCTAssertNil(error)
        XCTAssertNotNil(ratesResponse)
    }
    
    override func tearDownWithError() throws {
        service = nil
    }
}
