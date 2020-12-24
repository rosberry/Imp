//
//  Copyright © 2020 Rosberry. All rights reserved.
//

import XCTest
import Imp

class ImageTests: XCTestCase {

    func makeImage(withName imageName: String) -> Image<NamedImageProvider> {
        return Image(named: imageName, in: Bundle(for: Self.self))
    }

    func testImageFetch() throws {
        let image = makeImage(withName: "example-1.jpg")
        XCTAssert(image() != nil)
    }

    func testEquatable() {
        let firstImage = makeImage(withName: "example-1.jpg")
        let secondImage = makeImage(withName: "example-2.png")
        XCTAssert(firstImage == firstImage)
        XCTAssert(secondImage == secondImage)
        XCTAssert(firstImage != secondImage)
    }

    func testHashable() {
        let firstImage = makeImage(withName: "example-1.jpg")
        let secondImage = makeImage(withName: "example-2.png")
        XCTAssert(firstImage.hashValue == firstImage.hashValue)
        XCTAssert(secondImage.hashValue == secondImage.hashValue)
        XCTAssert(firstImage.hashValue != secondImage.hashValue)
    }

    func testCodable() {
        let image = makeImage(withName: "example-1.jpg")
        guard let data = try? JSONEncoder().encode(image) else {
            return XCTFail("Encoding failed")
        }

        guard let decodedImage = try? JSONDecoder().decode(type(of: image), from: data) else {
            return XCTFail("Decoding failed")
        }

        XCTAssert(image == decodedImage)
    }

    func testCaching() {
        let image = Image(size: .init(width: 40.0, height: 40.0), actions: { _ in })
        let uiImage = image()
        XCTAssert(uiImage == image())

        image.dropCache()
        XCTAssert(uiImage != image())
    }

    func testQuickLook() {
        let image = makeImage(withName: "example-1.jpg")
        XCTAssert(image.debugQuickLookObject() is UIImage)
    }
}
