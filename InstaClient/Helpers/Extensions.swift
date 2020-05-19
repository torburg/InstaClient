//
//  Extensions.swift
//  InstaClient
//
//  Created by Maksim Torburg on 15.05.2020.
//  Copyright © 2020 Maksim Torburg. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Images are too large to display correctly w/o
func resized(_ image: UIImage, to size: CGSize) -> UIImage {
    let maxSize = image.size.width > image.size.height ? image.size.width : image.size.height
    let scale = size.width / maxSize
    let newHeight = image.size.height * scale
    
    let reneder = UIGraphicsImageRenderer(size: CGSize(width: size.width, height: newHeight))
    let resizedImage = reneder.image { (context) in
        image.draw(in: CGRect(origin: .zero, size: CGSize(width: size.width, height: newHeight)))
    }
    return resizedImage
}

