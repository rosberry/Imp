//
//  Copyright © 2020 Rosberry. All rights reserved.
//

import UIKit.UIImage

/// An object that wraps and manages storage of CGImage objects.
public final class CoreGraphicsImageProvider: ImageProvider {
    enum CodingKeys: String, CodingKey {
        case data
    }

    /// A CGImage instance managed by the provider.
    public var cgImage: CGImage

    /**
    Initializes a new provider object with CGImage instance.
     
    - Parameters:
       - cgImage: A CGImage instance to be managed.
    - Returns: A newly created provider instance.
    */
    public init(cgImage: CGImage) {
        self.cgImage = cgImage
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
    }

    /// Returns an UIImage instance that uses a CGImage provided as a backing storage.
    public func fetchImage() -> UIImage? {
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

extension CoreGraphicsImageProvider: Equatable {
    public static func == (lhs: CoreGraphicsImageProvider, rhs: CoreGraphicsImageProvider) -> Bool {
        return lhs.cgImage == rhs.cgImage
    }
}

// MARK: - Hashable

extension CoreGraphicsImageProvider: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(cgImage)
    }
}
