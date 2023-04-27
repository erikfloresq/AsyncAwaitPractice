//
//  AsyncAwaitPracticeTests.swift
//  AsyncAwaitPracticeTests
//
//  Created by Erik Flores on 26/04/23.
//

import XCTest
@testable import AsyncAwaitPractice

final class AsyncAwaitPracticeTests: XCTestCase {
    var sut: ViewModel!

    override func setUpWithError() throws {
        sut = ViewModel()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testGetData() async throws {
        let response = try await sut.getData()
        XCTAssertEqual(response.characters, "https://rickandmortyapi.com/api/character")
    }
    
    func testGetSequentialData() async throws {
        let response = try await sut.getSequentialData()
        XCTAssertEqual(response, 60)
    }
    
    func testGetDataInParallel() async throws {
        let response = try await sut.getDataInParallel()
        XCTAssertEqual(response, 3)
    }
    
    func testGetInGroup() async throws {
        let response = try await sut.getInGroup()
        XCTAssertEqual(response.count, 3)
    }
}
