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
    
    @IBOutlet weak var mainAvatar: UIImageView!
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var geo: UILabel!
    @IBOutlet weak var mainPhoto: UIImageView!
    @IBOutlet weak var content: UITextField!
    
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
        content.text = post.description
    }
}
