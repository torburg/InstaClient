//
//  Extensions.swift
//  InstaClient
//
//  Created by Maksim Torburg on 15.05.2020.
//  Copyright © 2020 Maksim Torburg. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Images are too large to display correctly w/o resizing
// FIXME: - Fix proportional resizing
func resized(_ image: UIImage, to size: CGSize) -> UIImage {
    let renderer = UIGraphicsImageRenderer(size: size)
    let resizedImage = renderer.image { (context) in
        image.draw(in: CGRect(origin: .zero, size: size))
    }
    return resizedImage
}

