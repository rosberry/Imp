//
//  Copyright © 2020 Rosberry. All rights reserved.
//

import UIKit.UIImage

public protocol AnyImage: Codable {
    var image: UIImage? { get }

    func callAsFunction() -> UIImage?
    func fetch(on queue: DispatchQueue, completion: @escaping (UIImage?) -> Void)

    func dropCache()
    func debugQuickLookObject() -> Any
}
