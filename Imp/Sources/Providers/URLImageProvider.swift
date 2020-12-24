//
//  Copyright © 2020 Rosberry. All rights reserved.
//

import UIKit.UIImage

/// An object that fetches images from the specified URL.
public final class URLImageProvider: ImageProvider {
    enum CodingKeys: String, CodingKey {
        case url
    }

    /// An URL of the image to be fetched.
    public let url: URL

    /**
    Initializes a new provider object with specified URL.
     
    - Parameters:
       - url: An URL of the image to be fetched.
    - Returns: A newly created provider instance.
    */
    public init(url: URL) {
        self.url = url
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        url = try container.decode(URL.self, forKey: .url).resolvingRelativeURL
    }

    /// Returns an UIImage instance referenced by the URL provider was initialized with. Works synchronously.
    public func fetchImage() -> UIImage? {
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }

        return UIImage(data: data)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(url.relativeURL, forKey: .url)
    }
}

// MARK: - Equatable

extension URLImageProvider: Equatable {
    public static func == (lhs: URLImageProvider, rhs: URLImageProvider) -> Bool {
        return lhs.url == rhs.url
    }
}

// MARK: - Hashable

extension URLImageProvider: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(url)
    }
}
