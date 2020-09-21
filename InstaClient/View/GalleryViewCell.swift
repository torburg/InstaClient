//
//  GalleryViewCell.swift
//  InstaClient
//
//  Created by Maksim Torburg on 26.05.2020.
//  Copyright © 2020 Maksim Torburg. All rights reserved.
//

import Foundation
import UIKit

class GalleryViewCell: UICollectionViewCell {
    static var reuseID = "reuseID"
    var user: User?
    var dataManager: DataManagerProtocol?
    var imageView = UIImageView()
    let indicator = UIActivityIndicatorView(style: .medium)
    
    func onBind(for indexPath: IndexPath) {
        contentView.addSubview(imageView)

        contentView.addSubview(indicator)
        indicator.center = contentView.center
        indicator.startAnimating()
        
        guard dataManager != nil else { return }
        guard let currentUser = user else {
            let post = dataManager!.getPost(by: indexPath)
            setData(with: post)
            return
        }
        dataManager!.asyncGetPost(of: currentUser, for: indexPath) { (post) in
            self.setData(with: post)
        }
    }
    
    func setData(with post: Post) {
        indicator.stopAnimating()
        indicator.removeFromSuperview()
        guard let image = post.photo else { return }
        
        // FIXME: - Fix filling cell with image with proportional scaling
        let cellSize = self.bounds.size
        DispatchQueue.global(qos: .utility).async {
            let resizedImage = resized(image, to: cellSize)
            DispatchQueue.main.async {

                self.imageView = UIImageView(image: resizedImage)
                self.imageView.contentMode = .scaleToFill

                self.contentView.addSubview(self.imageView)
                self.contentMode = .scaleAspectFit
            }
        }
    }
    
    override func prepareForReuse() {
        imageView.image = UIImage()
    }
}
