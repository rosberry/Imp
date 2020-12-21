//
//  Copyright © 2020 Rosberry. All rights reserved.
//

import UIKit.UIImage

public protocol ImageProvider: Codable, Hashable {
    func fetchImage() -> UIImage?
}
