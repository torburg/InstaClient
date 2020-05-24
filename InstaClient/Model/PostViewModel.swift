//
//  PostViewModel.swift
//  InstaClient
//
//  Created by Maksim Torburg on 23.05.2020.
//  Copyright © 2020 Maksim Torburg. All rights reserved.
//

import Foundation

class PostViewModel {
    var post: Post?
    
    var postIndex: Int?
    
    var authorAvatarUrl: String {
        return post?.author.avatar ?? ""
    }
    var authorName: String {
        return post?.author.name ?? ""
    }
    var mainPhoto: String {
        return post?.photo ?? ""
    }
    var likeImageUrl: String {
        switch isLiked {
        case true: return "liked"
        case false: return "like"
        }
    }
    var likesText: String {
        return " \(post?.likes ?? 0) likes"
    }
    var contentText: String {
        return post?.description ?? ""
    }

    func getData(by index: Int, completion: @escaping (PostViewModel)->Void) {
        DataManager.shared.asyncGetPost(for: index) { (post) in
            self.post = post
            completion(self)
        }
    }

    var isLiked: Bool {
        get {
            guard let currentUser = DataManager.shared.getCurrentUser() else { return false }
            guard let likedPosts = DataManager.shared.getLikedPosts(of: currentUser) else { return false }
            guard let currentPost = post else { return false }
            return likedPosts.contains(where: { $0 == currentPost })
        }
        set {
            guard let currentUser = DataManager.shared.getCurrentUser() else { return }
            guard var likedPosts = DataManager.shared.getLikedPosts(of: currentUser) else { return }
            guard let currentPost = post else { return }
            switch newValue {
            case true:
                let updatedPosts = likedPosts.filter { $0 != currentPost}
                DataManager.shared.updateLikedPosts(with: updatedPosts, of: currentUser)
                self.isLiked = false
            case false:
                likedPosts.append(currentPost)
                DataManager.shared.updateLikedPosts(with: likedPosts, of: currentUser)
                self.isLiked = true
            }
        }
    }
    
    static func == (lhs: PostViewModel, rhs: PostViewModel) -> Bool {
        guard let leftSideValue = lhs.post, let rightSideValue = rhs.post else { return false }
        return leftSideValue == rightSideValue
    }
    
    static func != (lhs: PostViewModel, rhs: PostViewModel) -> Bool {
        return !(lhs == rhs)
    }
}
