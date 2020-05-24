//
//  PostViewCell.swift
//  InstaClient
//
//  Created by Maksim Torburg on 19.05.2020.
//  Copyright © 2020 Maksim Torburg. All rights reserved.
//

import UIKit

class PostViewCell: UITableViewCell {
    
    static let reuseID = "PostListCellView"
    
    var post = PostViewModel()
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var mainAvatar: UIImageView!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var geo: UILabel!
    @IBOutlet weak var mainPhoto: UIImageView!
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var likes: UILabel!

    @IBAction func likePressed(_ sender: Any) {
        post.isLiked.toggle()
        likeButton.setImage(UIImage(named: post.likeImageUrl),for: .normal)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainAvatar.layer.cornerRadius = mainAvatar.frame.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func onBind(for index: Int) {
        // MARK: - Filling cell with empty PostViewModel
        fillCell(with: PostViewModel())
        
        post.getData(by: index, completion: { [weak self] (post) in
            guard let self = self else { return }
            // MARK: - Check do we get the model in the same cell, we need to do thsis cause async
            if self.post == post {
                self.fillCell(with: post)
            }
        })
    }

    func fillCell(with post: PostViewModel) {
        self.post = post
        
        if !post.authorAvatarUrl.isEmpty {
           mainAvatar.image = UIImage(named: post.authorAvatarUrl)
        } else {
           mainAvatar.image = UIImage()
        }
        authorName.text = post.authorName
        if !post.mainPhoto.isEmpty {
           mainPhoto.image = UIImage(named: post.mainPhoto)
        } else {
           mainPhoto.image = UIImage()
        }
        if !post.likeImageUrl.isEmpty {
           likeButton.imageView?.image = UIImage(named: post.likeImageUrl)
        } else {
           likeButton.imageView?.image = UIImage()
        }
        likes.text = post.likesText

        content.text = post.contentText
        content.textContainer.maximumNumberOfLines = 3
    }
}
