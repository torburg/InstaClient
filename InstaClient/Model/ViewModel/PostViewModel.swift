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

    var authorName: String {
        return post?.author.name ?? ""
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
        return post?.content ?? ""
    }

    func getData(for user: User, by indexPath: IndexPath, completion: @escaping (PostViewModel)->Void) {
        DataManager.shared.asyncGetPost(of: user, for: indexPath) { (post) in
            self.post = post
            completion(self)
        }
    }

    var isLiked = false //Bool {
//        get {
//            guard let currentPost = post else { return false }
//            guard let likedPosts = DataManager.shared.getLikedPosts(of: currentPost.author) else { return false }
//            return likedPosts.contains(where: { $0 == currentPost })
//        }
//        set {
//            if isLiked != newValue {
//                guard let currentPost = post else { return }
////                guard var likedPosts = DataManager.shared.getLikedPosts(of: currentPost.author) else { return }
//                switch newValue {
//                case true:
//                    likedPosts.append(currentPost)
//                    DataManager.shared.updateLikedPosts(with: likedPosts, of: currentPost.author)
//                    self.isLiked = newValue
//                case false:
//                    let updatedPosts = likedPosts.filter { $0 != currentPost}
//                    DataManager.shared.updateLikedPosts(with: updatedPosts, of: currentPost.author)
//                    self.isLiked = newValue
//                }
//            }
//        }
//    }
    
    static func == (lhs: PostViewModel, rhs: PostViewModel) -> Bool {
        guard let leftSideValue = lhs.post, let rightSideValue = rhs.post else { return false }
        return leftSideValue == rightSideValue
    }
    
    static func != (lhs: PostViewModel, rhs: PostViewModel) -> Bool {
        return !(lhs == rhs)
    }
}
