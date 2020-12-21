//
//  Copyright © 2020 Rosberry. All rights reserved.
//

import UIKit.UIImage

public final class URLImageProvider: ImageProvider {
    enum CodingKeys: String, CodingKey {
        case url
    }

    public let url: URL

    public init(url: URL) {
        self.url = url
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        url = try container.decode(URL.self, forKey: .url).resolvingRelativeURL
    }

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
