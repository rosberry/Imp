//
//  Copyright © 2020 Rosberry. All rights reserved.
//

import UIKit.UIImage

public protocol AnyImage: Codable {
    /// An UIImage that's managed by the current instance. If no UIImage exists yet, it will be fetched synchronously on access.
    var image: UIImage? { get }

    /// Fetches an UIImage synchronously.
    func callAsFunction() -> UIImage?

    /**
    Fetches an UIImage asynchonously.
     
    - Parameters:
       - queue: A DispatchQueue that should be used for image fetch.
       - completion: A handler that will be executed after image was fetched. Called on main thread.
    - Returns: A newly created Image instance.
    */
    func fetch(on queue: DispatchQueue, completion: @escaping (UIImage?) -> Void)

    /// Dereferences managed UIImage instance.
    func dropCache()
    func debugQuickLookObject() -> Any
}
