//
//  Copyright © 2020 Rosberry. All rights reserved.
//

import UIKit

extension UIButton {
    /// Updates UIButton with a provided Image object.
    public func setImage(_ image: AnyImage, for state: UIButton.State) {
        setImage(image.image, for: state)
    }
}
