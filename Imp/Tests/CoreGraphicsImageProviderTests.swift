//
//  Copyright © 2020 Rosberry. All rights reserved.
//

import XCTest
import Imp

class CoreGraphicsImageProviderTests: ProviderTests {

    func makeProvider(forImageName imageName: String) -> CoreGraphicsImageProvider {
        let image = UIImage(named: imageName, in: bundle, compatibleWith: nil)
        guard let cgImage = image?.cgImage else {
            XCTFail("Missing resource")
            fatalError("Missing resource")
        }

        return CoreGraphicsImageProvider(cgImage: cgImage)
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
