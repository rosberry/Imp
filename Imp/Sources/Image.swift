//
//  Copyright © 2020 Rosberry. All rights reserved.
//

import UIKit.UIImage

/// An object that controls UIImage lifecycle and storage.
public final class Image<Provider: ImageProvider>: AnyImage, Codable {
    enum CodingKeys: String, CodingKey {
        case provider
    }

    /// An object that's used for UIImage fetching.
    public let provider: Provider

    /// An UIImage that's managed by the current instance. If no UIImage exists yet, it will be fetched synchronously on access.
    @Cached public private(set) var image: UIImage?

    /**
    Initializes a new Image object.
     
    - Parameters:
       - provider: A provider object that will be used for UIImage fetch.
    - Returns: A newly created Image instance.
    */
    public init(provider: Provider) {
        self.provider = provider
        _image.provider = provider.fetchImage
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        provider = try container.decode(Provider.self, forKey: .provider)
        _image.provider = provider.fetchImage
    }

    /// Fetches an UIImage synchronously.
    public func callAsFunction() -> UIImage? {
        return image
    }

    /**
    Fetches an UIImage asynchonously.
     
    - Parameters:
       - queue: A DispatchQueue that should be used for image fetch.
       - completion: A handler that will be executed after image was fetched. Called on main thread.
    - Returns: A newly created Image instance.
    */
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

    /// Releases managed UIImage instance.
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

extension Image where Provider == NamedImageProvider {
    /**
    Initializes a new Image object with URLImageProvider.
     
    - Parameters:
       - name: A name of the image to be fetched.
       - bundle: A bundle that will be queried. Default is main bundle.
    - Returns: A newly created Image instance.
    */
    public convenience init(named name: String, in bundle: Bundle = .main) {
        self.init(provider: .init(name: name, bundle: bundle))
    }
}

extension Image where Provider == URLImageProvider {
    /**
    Initializes a new Image object with URLImageProvider.
     
    - Parameters:
       - url: An URL of the image to be fetched.
    - Returns: A newly created Image instance.
    */
    public convenience init(url: URL) {
        self.init(provider: .init(url: url))
    }
}

extension Image where Provider == CoreGraphicsImageProvider {
    /**
    Initializes a new Image object with CoreGraphicsImageProvider.
     
    - Parameters:
       - cgImage: A CGImage instance to be managed.
    - Returns: A newly created Image instance.
    */
    public convenience init(cgImage: CGImage) {
        self.init(provider: .init(cgImage: cgImage))
    }
}

extension Image where Provider == BitmapContextImageProvider {
    /**
    Initializes a new Image object with BitmapContextImageProvider.
     
    - Parameters:
       - size: A size of the output image.
       - colorSpace: A colorspace of the output image.
       - actions: A handler that will be called during image generation. It should perform drawing on the calling thread.
     CGContext is already flipped vertically for convenience.
    - Returns: A newly created Image instance.
    */
    public convenience init(size: CGSize,
                            colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB(),
                            actions: @escaping (CGContext) -> Void) {
        self.init(provider: .init(size: size, colorSpace: colorSpace, actions: actions))
    }
}
