//
//  Copyright © 2020 Rosberry. All rights reserved.
//

import UIKit.UIImage

public final class NamedImageProvider: ImageProvider {
    public let name: String

    public init(name: String) {
        self.name = name
    }

    public func fetchImage() -> UIImage? {
        return UIImage(named: name)
    }
}

// MARK: - Equatable

extension NamedImageProvider: Equatable {
    public static func == (lhs: NamedImageProvider, rhs: NamedImageProvider) -> Bool {
        return lhs.name == rhs.name
    }
}

// MARK: - Hashable

extension NamedImageProvider: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
