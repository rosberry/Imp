//
//  Copyright © 2020 Rosberry. All rights reserved.
//

import UIKit
import Imp

final class ExampleViewController: UIViewController {
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        cycleImages()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = view.bounds
    }
    
    private func cycleImages() {
        imageView.setImage(Image(named: "Image1"))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if let image = UIImage(named: "Image2")?.cgImage {
                self.imageView.setImage(Image(cgImage: image))
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if let url = Bundle.main.url(forResource: "Image3.jpg", withExtension: nil) {
                self.imageView.setImage(Image(url: url))
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            let image = Image(size: .init(width: 320, height: 320)) { (context: CGContext) in
                context.setStrokeColor(UIColor.red.cgColor)
                context.move(to: .zero)
                context.addLine(to: .init(x: 320, y: 320))
                context.strokePath()
            }
            self.imageView.setImage(image)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            self.cycleImages()
        }
    }
}
