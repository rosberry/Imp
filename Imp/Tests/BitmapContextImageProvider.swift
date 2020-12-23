//
//  Copyright © 2020 Rosberry. All rights reserved.
//

import XCTest
import Imp

class BitmapContextImageProviderTests: ProviderTests {

    func makeProvider(size: CGSize = .init(width: 120.0, height: 120.0),
                      colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB(),
                      color: UIColor) -> BitmapContextImageProvider {
        return BitmapContextImageProvider(size: size, colorSpace: colorSpace, actions: { (context: CGContext) in
            context.setFillColor(color.cgColor)
            context.fill(.init(origin: .zero, size: size))
        })
    }

    func testImageFetch() throws {
        let provider = makeProvider(color: .red)
        guard let image = provider.fetchImage() else {
            XCTFail("No image")
            return
        }

        XCTAssert(image.size == provider.size)

        guard let data = image.cgImage?.dataProvider?.data,
              let pointer = CFDataGetBytePtr(data) else {
            XCTFail("No image data")
            return
        }

        // Check for red with ARGB byte order
        XCTAssert(pointer.pointee == 0xFF)
        XCTAssert(pointer.advanced(by: 1).pointee == 0xFF)
        XCTAssert(pointer.advanced(by: 2).pointee == 0)
        XCTAssert(pointer.advanced(by: 3).pointee == 0)
    }

    func testEquatable() {
        let firstProvider = makeProvider(color: .red)
        let secondProvider = makeProvider(color: .green)

        // Bitmap context providers always regenerates image on fetch, so the only meaningful equatable check here
        // is to check that it in fact returns different instances
        XCTAssert(firstProvider != secondProvider)
    }

    func testHashable() {
        let firstProvider = makeProvider(color: .red)
        let secondProvider = makeProvider(color: .green)

        // Bitmap context providers always regenerates image on fetch, so the only meaningful equatable check here
        // is to check that it in fact returns different instances
        XCTAssert(firstProvider.hashValue != secondProvider.hashValue)
    }

    func testCodable() {
        let provider = makeProvider(color: .green)
        testCodable(for: provider)
    }
}
