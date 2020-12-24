//
//  Copyright © 2020 Rosberry. All rights reserved.
//

import Foundation
import UIKit.UIImage

@propertyWrapper public class Cached<Value: AnyObject> {
    public var provider: (() -> Value?)?
    lazy var storage: NSCache<Cached<Value>, Value> = .init()

    public var wrappedValue: Value? {
        get {
            if let object = storage.object(forKey: self) {
                return object
            }

            if let object = provider?() {
                storage.setObject(object, forKey: self)
                return object
            }

            return nil
        }
        set {
            if let value = newValue {
                storage.setObject(value, forKey: self)
            }
            else {
                storage.removeObject(forKey: self)
            }
        }
    }

    public var hasValue: Bool {
        return storage.object(forKey: self) != nil
    }

    public init() {}

    @objc func isEqual(_ object: Any?) -> Bool {
        return self === object as AnyObject
    }
}
