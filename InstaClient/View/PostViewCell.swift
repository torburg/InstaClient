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
    
    var postViewModel = PostViewModel()
    var user: User?
    weak var delegate: PostsListViewProtocol? = nil
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var mainAvatar: UIImageView!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var geo: UILabel!
    @IBOutlet weak var mainPhoto: UIImageView!
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var likes: UILabel!

    @IBAction func likePressed(_ sender: Any) {
//        postViewModel.isLiked.toggle()
        likeButton.setImage(UIImage(named: postViewModel.likeImageUrl),for: .normal)
    }

    @IBAction func editButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        guard let actionDelegate = delegate as? PostsListViewController else { return }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] action in
            self?.postViewModel.delete { (response, index) in
                if response == Response.success {
                    actionDelegate.deletePost(at: index)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        actionDelegate.present(alert, animated: true, completion: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainAvatar.layer.cornerRadius = mainAvatar.frame.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func onBind(for indexPath: IndexPath) {
        // MARK: - Filling cell with empty PostViewModel
        fillCell(with: PostViewModel())
        guard let currentUser = user else { return }
        postViewModel.getData(for: currentUser, by: indexPath, completion: { [weak self] (post) in
            guard let self = self else { return }
            // MARK: - Check do we get the model in the same cell, we need to do thsis cause async
            if self.postViewModel == post {
                self.fillCell(with: post)
            }
        })
    }

    func fillCell(with postViewModel: PostViewModel) {
        self.postViewModel = postViewModel
        guard let dataDelegate = delegate as? PostsListViewController,
            let postsListPresenter = dataDelegate.presenter as? PostsListPresenter else { return }
        postViewModel.dataManager = postsListPresenter.dataManager
        if let avatarImage = postViewModel.post?.author.avatar {
            mainAvatar.image = resized(avatarImage, to: mainAvatar.frame.size)
        } else {
           mainAvatar.image = UIImage()
        }
        authorName.text = postViewModel.authorName
        if let mainImage = postViewModel.post?.photo {
           mainPhoto.image = mainImage
        } else {
           mainPhoto.image = UIImage()
        }
        if !postViewModel.likeImageUrl.isEmpty {
           likeButton.imageView?.image = UIImage(named: postViewModel.likeImageUrl)
        } else {
           likeButton.imageView?.image = UIImage()
        }
        likes.text = postViewModel.likesText

        content.text = postViewModel.contentText
        content.textContainer.maximumNumberOfLines = 3
    }
}
