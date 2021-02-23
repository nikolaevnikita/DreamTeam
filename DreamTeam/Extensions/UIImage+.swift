//
//  UIImage+.swift
//  DreamTeam
//
//  Created by Николаев Никита on 20.02.2021.
//

import UIKit

extension UIImage {
    enum ApplicationImage: String {
        case back = "back"
        case forward = "forward"
        case imagePlaceholder = "imagePlaceholder"
    }
    
    convenience init?(_ image: ApplicationImage) {
        self.init(named: image.rawValue)
    }
}
