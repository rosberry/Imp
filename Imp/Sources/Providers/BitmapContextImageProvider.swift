//
//  Copyright © 2020 Rosberry. All rights reserved.
//

import UIKit.UIImage

/// An object that generates image based on provided draw actions.
public final class BitmapContextImageProvider: ImageProvider {
    enum CodingKeys: String, CodingKey {
        case data
    }

    /// A size of the image that will be generated.
    public let size: CGSize

    /// A colorspace that will be used for drawing.
    public let colorSpace: CGColorSpace

    let actions: (CGContext) -> Void
    var cgImage: CGImage?

    /**
    Initializes a new provider object with specified size, colorspace and drawing actions. See `fetchImage()`.
     
    - Parameters:
       - size: A size of the output image.
       - colorSpace: A colorspace of the output image.
       - actions: A handler that will be called during image generation. It should perform drawing on the calling thread.
     CGContext is already flipped vertically for convenience.
    - Returns: A newly created provider instance.
    */
    public init(size: CGSize, colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB(), actions: @escaping (CGContext) -> Void) {
        self.size = size
        self.colorSpace = colorSpace
        self.actions = actions
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let data = try container.decode(Data.self, forKey: .data)
        guard let provider = CGDataProvider(data: data as CFData) else {
            throw ImageCodingError.noProvider
        }

        guard let cgImage = CGImage(pngDataProviderSource: provider,
                                    decode: nil,
                                    shouldInterpolate: false,
                                    intent: .defaultIntent) else {
            throw ImageCodingError.noImage
        }

        self.cgImage = cgImage
        size = .init(width: cgImage.width, height: cgImage.height)
        colorSpace = cgImage.colorSpace ?? CGColorSpaceCreateDeviceRGB()
        actions = { _ in }
    }

    /// Returns an UIImage instance by creating a CGContext with a given size / colorspace
    /// and executing actions handler that was passed during initialization.
    public func fetchImage() -> UIImage? {
        if let cgImage = cgImage {
            return UIImage(cgImage: cgImage)
        }

        let bytesPerPixel = 4
        let bitsPerComponent = 8
        let width = Int(size.width)
        let height = Int(size.height)
        let bitmapInfo = CGImageAlphaInfo.premultipliedFirst.rawValue
        guard let context = CGContext(data: nil,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: bitsPerComponent,
                                      bytesPerRow: width * bytesPerPixel,
                                      space: colorSpace,
                                      bitmapInfo: bitmapInfo) else {
            return nil
        }

        context.scaleBy(x: 1.0, y: -1.0)
        context.translateBy(x: 0.0, y: -size.height)
        actions(context)

        guard let cgImage = context.makeImage() else {
            return nil
        }

        return UIImage(cgImage: cgImage)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        guard let data = fetchImage()?.pngData() else {
            throw ImageCodingError.noData
        }
        try container.encode(data, forKey: .data)
    }
}

// MARK: - Equatable

extension BitmapContextImageProvider: Equatable {
    public static func == (lhs: BitmapContextImageProvider, rhs: BitmapContextImageProvider) -> Bool {
        return lhs.fetchImage()?.cgImage == rhs.fetchImage()?.cgImage
    }
}

// MARK: - Hashable

extension BitmapContextImageProvider: Hashable {
    public func hash(into hasher: inout Hasher) {
        _ = fetchImage()
        hasher.combine(cgImage)
    }
}
