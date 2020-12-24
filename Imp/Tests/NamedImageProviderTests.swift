//
//  Copyright © 2020 Rosberry. All rights reserved.
//

import XCTest
import Imp

class NamedImageProviderTests: ProviderTests {

    func testImageFetch() throws {
        let provider = NamedImageProvider(name: "example-1.jpg", bundle: bundle)
        testImageFetch(for: provider)
    }

    func testEquatable() {
        let firstProvider = NamedImageProvider(name: "example-1.jpg", bundle: bundle)
        let secondProvider = NamedImageProvider(name: "example-2.png", bundle: bundle)
        testEquatable(lhs: firstProvider, rhs: secondProvider)
    }

    func testHashable() {
        let firstProvider = NamedImageProvider(name: "example-1.jpg", bundle: bundle)
        let secondProvider = NamedImageProvider(name: "example-2.png", bundle: bundle)
        testHashable(lhs: firstProvider, rhs: secondProvider)
    }

    func testCodable() {
        let provider = NamedImageProvider(name: "example-1.jpg", bundle: bundle)
        testCodable(for: provider)
    }
}
