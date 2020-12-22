//
//  Copyright © 2020 Rosberry. All rights reserved.
//

import UIKit.UIImage

/// An object that fetches images from the bundle storage.
public final class NamedImageProvider: ImageProvider {
    /// A name of the image to be fetched.
    public let name: String

    /**
    Initializes a new provider object with specified image name.
     
    - Parameters:
       - name: A name of the image to be fetched.
    - Returns: A newly created provider instance.
    */
    public init(name: String) {
        self.name = name
    }

    /// Returns an UIImage instance referenced by the name provider was initialized with. 
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
