//
//  ServiceTest.swift
//  CurrencyTests
//
//  Created by gamal oraby on 03/06/2023.
//

import XCTest
@testable import Currency

class ServiceTest: XCTestCase {
    
    var service: RatesAPI!
    
    override func setUpWithError() throws {
        self.service = RatesAPI()
    }
    
    override func setUp() async throws {
        self.service = RatesAPI()
    }
    
    func testGetRates() {
        let expectation = self.expectation(description: "Waiting for the retrieveAlumni call to complete.")
        var error: Error?
        var ratesResponse: RatesResponse?
        service.getRates { (response, err) in
           
            error = err
            ratesResponse = response
            XCTAssertNil(error)
            XCTAssertNotNil(ratesResponse)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 3)
       
    }
    
    override func tearDownWithError() throws {
        service = nil
    }
}
