//
//  Copyright © 2020 Rosberry. All rights reserved.
//

import XCTest
import Imp

class URLImageProviderTests: ProviderTests {

    func makeProvider(forImageName imageName: String) -> URLImageProvider {
        guard let url = bundle.url(forResource: imageName, withExtension: nil) else {
            XCTFail("Missing resource")
            fatalError("Missing resource")
        }

        return URLImageProvider(url: url)
    }

    func testImageFetch() throws {
        let provider = makeProvider(forImageName: "example-1.jpg")
        testImageFetch(for: provider)
    }

    func testEquatable() {
        let firstProvider = makeProvider(forImageName: "example-1.jpg")
        let secondProvider = makeProvider(forImageName: "example-2.png")
        testEquatable(lhs: firstProvider, rhs: secondProvider)
    }

    func testHashable() {
        let firstProvider = makeProvider(forImageName: "example-1.jpg")
        let secondProvider = makeProvider(forImageName: "example-2.png")
        testHashable(lhs: firstProvider, rhs: secondProvider)
    }

    func testCodable() {
        let provider = makeProvider(forImageName: "example-1.jpg")
        testCodable(for: provider)
    }
}
