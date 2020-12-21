//
//  Copyright © 2020 Rosberry. All rights reserved.
//

import UIKit.UIImage

public final class Image<Provider: ImageProvider>: AnyImage, Codable {
    enum CodingKeys: String, CodingKey {
        case provider
    }

    public let provider: Provider
    @Cached public private(set) var image: UIImage?

    public init(provider: Provider) {
        self.provider = provider
        _image.provider = provider.fetchImage
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        provider = try container.decode(Provider.self, forKey: .provider)
        _image.provider = provider.fetchImage
    }

    public func callAsFunction() -> UIImage? {
        return image
    }

    public func fetch(on queue: DispatchQueue = .global(), completion: @escaping (UIImage?) -> Void) {
        guard _image.hasValue == false else {
            return completion(image)
        }

        queue.async {
            let image = self.image
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }

    public func dropCache() {
        _image.storage.removeAllObjects()
    }

    @objc public func debugQuickLookObject() -> Any {
        return image as Any
    }
}

// MARK: - Equatable

extension Image: Equatable {
    public static func == (lhs: Image<Provider>, rhs: Image<Provider>) -> Bool {
        return lhs.provider == rhs.provider
    }
}

// MARK: - Hashable

extension Image: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(provider)
    }
}

// MARK: - Convenience

extension Image {
    public convenience init(named name: String) where Provider == NamedImageProvider {
        self.init(provider: .init(name: name))
    }

    public convenience init(url: URL) where Provider == URLImageProvider {
        self.init(provider: .init(url: url))
    }

    public convenience init(cgImage: CGImage) where Provider == CoreGraphicsImageProvider {
        self.init(provider: .init(cgImage: cgImage))
    }

    public convenience init(size: CGSize,
                            colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB(),
                            actions: @escaping (CGContext) -> Void) where Provider == BitmapContextImageProvider {
        self.init(provider: .init(size: size, colorSpace: colorSpace, actions: actions))
    }
}
