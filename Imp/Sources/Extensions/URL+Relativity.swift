//
//  Copyright © 2020 Rosberry. All rights reserved.
//

import Foundation

extension URL {

    static let bundleStorageURLScheme: String = "bundle"
    static let homeStorageURLScheme: String = "home"

    var bundleRelativeURL: URL? {
        let bundleURL = Bundle.main.bundleURL.resolvingSymlinksInPath()
        return relativeURL(with: bundleURL, scheme: Self.bundleStorageURLScheme)
    }

    var homeRelativeURL: URL? {
        let homeURL = URL(fileURLWithPath: NSHomeDirectory()).resolvingSymlinksInPath()
        return relativeURL(with: homeURL, scheme: Self.homeStorageURLScheme)
    }

    var relativeURL: URL {
        return bundleRelativeURL ?? homeRelativeURL ?? self
    }

    var resolvingRelativeURL: URL {
        return URL.resolving(relativeURL: self)
    }

    static func resolving(relativeURL: URL) -> URL {
        switch relativeURL.scheme {
        case Self.bundleStorageURLScheme:
            let bundleURL = Bundle.main.bundleURL
            return bundleURL.appendingPathComponent(relativeURL.path)
        case Self.homeStorageURLScheme:
            let homeURL = URL(fileURLWithPath: NSHomeDirectory())
            return homeURL.appendingPathComponent(relativeURL.path)
        default:
            return relativeURL
        }
    }

    func relativeURL(with baseURL: URL, scheme: String) -> URL? {
        let path = resolvingSymlinksInPath().path
        guard let range = path.range(of: baseURL.path) else {
            return nil
        }

        let relativePath = path.replacingCharacters(in: range, with: "")
        return URL(string: "\(scheme)://\(relativePath)")
    }
}
