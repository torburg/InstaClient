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
    
    var post: Post?
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var mainAvatar: UIImageView!
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var geo: UILabel!
    @IBOutlet weak var mainPhoto: UIImageView!
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var likes: UILabel!
    
    var isPostLiked: DataManager.Like? {
        didSet {
            switch isPostLiked {
            case .liked:
                DispatchQueue.main.async {
                    self.likeButton.imageView?.image = UIImage(named: "liked")
                }
            case .unliked:
                DispatchQueue.main.async {
                    self.likeButton.imageView?.image = UIImage(named: "like")
                }
            default:
                DispatchQueue.main.async {
                    self.likeButton.imageView?.image = UIImage(named: "like")
                }
            }
        }
    }
    
    @IBAction func likePressed(_ sender: Any) {
        let currentUser = DataManager.shared.getCurrentUser()
        guard let userName = currentUser?.name else { return }
        guard let post = post else { return }
        
        switch isPostLiked {
        case .liked:
            DataManager.shared.likedPosts?[userName]?.removeAll(where: { $0 == post })
            self.isPostLiked = .unliked
        case .unliked:
            DataManager.shared.likedPosts?[userName]?.append(post)
            self.isPostLiked = .liked
        default:
            return
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainAvatar.layer.cornerRadius = mainAvatar.frame.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func fillData(with post: Post) {
        self.post = post
        let user = post.author
        mainAvatar.image = {
            guard let avatarURL = user.avatar else { return UIImage() }
            guard let image = UIImage(named: avatarURL) else { return UIImage() }
            return resized(image, to: self.frame.size)
        }()
        ownerName.text = post.author.name
        mainPhoto.image = {
            let photoURL = post.photo
            return UIImage(named: photoURL)
        }()
        
        let currentUser = DataManager.shared.getCurrentUser()
        guard let userName = currentUser?.name else { return }
        guard let likedPosts = DataManager.shared.likedPosts?[userName] else { return }
        if likedPosts.contains(where: { $0 == self.post! }) {
            isPostLiked = .liked
        } else {
            isPostLiked = .unliked
        }

        likes.text = "\(post.likes ?? 0) likes"
        
        let author = post.author.name
        let boldAttributes: [NSAttributedString.Key : Any] = [
            .font : UIFont.boldSystemFont(ofSize: 15)
        ]
        let attributedText = NSMutableAttributedString(string: author, attributes: boldAttributes)
        let plainAttributes: [NSAttributedString.Key : Any] = [
            .font : UIFont.systemFont(ofSize: 15, weight: .regular),
            .kern : 0.2
        ]
        let description = NSMutableAttributedString(string: (post.description != nil) ? "   \(post.description!)" : "", attributes: plainAttributes)
        attributedText.append(description)
        content.attributedText = attributedText
        content.textContainer.maximumNumberOfLines = 3
    }
}
