//
//  Copyright © 2020 Rosberry. All rights reserved.
//

import XCTest
import Imp

class ProviderTests: XCTestCase {
    lazy var bundle: Bundle = Bundle(for: Self.self)

    func testImageFetch<Provider: ImageProvider>(for provider: Provider) {
        XCTAssert(provider.fetchImage() != nil)
    }

    func testEquatable<Provider: ImageProvider>(lhs: Provider, rhs: Provider) {
        XCTAssert(lhs == lhs)
        XCTAssert(rhs == rhs)
        XCTAssert(lhs != rhs)
    }

    func testHashable<Provider: ImageProvider>(lhs: Provider, rhs: Provider) {
        XCTAssert(lhs.hashValue == lhs.hashValue)
        XCTAssert(rhs.hashValue == rhs.hashValue)
        XCTAssert(lhs.hashValue != rhs.hashValue)
    }

    func testCodable<Provider: ImageProvider>(for provider: Provider) {
        guard let data = try? JSONEncoder().encode(provider) else {
            return XCTFail("Encoding failed")
        }

        guard let decodedProvider = try? JSONDecoder().decode(type(of: provider), from: data) else {
            return XCTFail("Decoding failed")
        }

        testImageFetch(for: decodedProvider)
    }
}
