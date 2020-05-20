//
//  DataManager.swift
//  InstaClient
//
//  Created by Maksim Torburg on 16.05.2020.
//  Copyright © 2020 Maksim Torburg. All rights reserved.
//

import Foundation

class DataManager {
    
    private var users: [User] = []
    private var currentUser: User? = nil

    func fetch(by name: String, completion: (User)->Void) {
        users = generateData()
        guard let user = users.first(where: { $0.name == name } ) else { return }
        currentUser = user
        completion(user)
    }
    
    func postCount() -> Int {
        return currentUser?.posts?.count ?? 0
    }
    
    func getIndex(for post: Post) -> Int? {
        guard let posts = currentUser?.posts else { return nil }
        return posts.firstIndex(where: { $0 == post })
    }
 
    func getPost(for index: Int, completion: (Post)->Void) {
        guard let posts = currentUser?.posts else { return }
        let post = posts[index]
        completion(post)
    }
    
    func syncGetPost(for index: Int) -> Post? {
        guard let posts = currentUser?.posts else { return nil }
        let post = posts[index]
        return post
    }
}


extension DataManager {
    
    
    private func generateData() -> [User] {
        let mf = User(avatar: "a_mf", name: "torburg_max", email: "torburg@yandex.ru", password: "max123", followers: 0, following: 5, posts: nil)
        let mfComments: [Comment] = [
            Comment(author: mf, text: "AWESOME", date: Date(), likes: 0),
            Comment(author: mf, text: "not bad", date: Date(), likes: 0),
            Comment(author: mf, text: "PUTIN!!11!!", date: Date(), likes: 1000),
        ]
        let mfPosts: [Post] = [
            Post(author: mf, photo: "color_study", description: "Kandinskiy", date: Date(), likes: 5, comments: mfComments.sorted(by: {$0.text < $1.text})),
            Post(author: mf, photo: "starry_night", description: "Van Gog", date: Date(), likes: 2, comments: mfComments.sorted(by: {$0.text > $1.text})),
            Post(author: mf, photo: "tomato_soup", description: "TOMAAATOOO", date: Date(), likes: 10, comments: mfComments.sorted(by: {$0.likes > $1.likes})),
            Post(author: mf, photo: "dali", description: "licking time", date: Date(), likes: 100000, comments: mfComments.sorted(by: {$0.likes > $1.likes})),
            Post(author: mf, photo: "picasso", description: "pcs", date: Date(), likes: 0, comments: mfComments.sorted(by: {$0.likes < $1.likes})),
        ]
        let torburg = User(avatar: mf.avatar, name: mf.name, email: mf.email, password: mf.password, followers: mf.followers, following: mf.following, posts: mfPosts)
        
        let sl = User(avatar: "slavatar", name: "sofya", email: "lapuloh@yandex.ru", password: "snya123", followers: 103, following: 515, posts: nil)
        let slComments: [Comment] = [
            Comment(author: mf, text: "AWESOME", date: Date(), likes: 0),
            Comment(author: mf, text: "fffffff", date: Date(), likes: 0),
            Comment(author: sl, text: "LUKASHENKO!!11!!", date: Date(), likes: 1000),
        ]
        let slPosts: [Post] = [
            Post(author: sl, photo: "sl1", description: "BW Face", date: Date(), likes: 50, comments: slComments.sorted(by: {$0.text < $1.text})),
            Post(author: sl, photo: "sl2", description: "BW Derevnja", date: Date(), likes: 0, comments: slComments.sorted(by: {$0.text > $1.text})),
        ]
        let sofya = User(avatar: sl.avatar, name: sl.name, email: sl.email, password: sl.password, followers: sl.followers, following: sl.following, posts: slPosts)
        
        return [torburg, sofya]
    }
}
