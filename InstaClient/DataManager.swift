//
//  DataManager.swift
//  InstaClient
//
//  Created by Maksim Torburg on 16.05.2020.
//  Copyright © 2020 Maksim Torburg. All rights reserved.
//

import Foundation

protocol DataManagerProtocol {
    func getAllUsers() -> [User]
    
    func syncGetUser(by name: String) -> User?
    
    func asyncGetUser(by name: String, completion: (User)->Void)

    func getCurrentUser() -> User?
    
    func getAllPosts(for user: User) -> [Post]?
    
    func syncGetPost(for index: Int) -> Post?
    
    func asyncGetPost(for index: Int, completion: (Post)->Void)
    
    func getIndex(for post: Post) -> Int?
    
    func asyncDeletePost(by index: Int, completion: (Bool)->Void)
}

class DataManager: DataManagerProtocol {
    
    static let shared = DataManager()
    
    private var users: [User] = []
    private var currentUser: User? = nil
    
    var likedPosts: [String : [Post]]? = nil
    
    init() {
        users = generateData()
    }
    
    func getAllUsers() -> [User] {
        return users
    }
    
    func syncGetUser(by name: String) -> User? {
        return users.filter{ $0.name == name}.first
    }

    func getCurrentUser() -> User? {
        return currentUser
    }
    
    func getAllPosts(for user: User) -> [Post]? {
        return syncGetUser(by: user.name)?.posts
    }
    
    func syncGetPost(for index: Int) -> Post? {
        guard let posts = currentUser?.posts else { return nil }
        let post = posts[index]
        return post
    }
    
    func asyncGetPost(for index: Int, completion: (Post)->Void) {
        guard let posts = currentUser?.posts else { return }
        let post = posts[index]
        completion(post)
    }
    
    func asyncGetUser(by name: String, completion: (User)->Void) {
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
    
    func asyncDeletePost(by index: Int, completion: (Bool)->Void) {
        guard let user = currentUser, let posts = getAllPosts(for: user) else { completion(false); return }
        let postToDelete = posts[index]
        let postsWithoutDeleted = user.posts?.filter{ $0 != postToDelete }
        let replacingUser = User(id: user.id, avatar: user.avatar, name: user.name, email: user.email, password: user.password, followers: user.followers, following: user.following, posts: postsWithoutDeleted)
        users.removeAll(where: { $0 == user })
        users.append(replacingUser)
        completion(true)
    }
}


extension DataManager {
    
    
    
    private func generateData() -> [User] {
        let mf = User(id: UUID(), avatar: "a_mf", name: "torburg_max", email: "torburg@yandex.ru", password: "max123", followers: 0, following: 5, posts: nil)
        let mfComments: [Comment] = [
            Comment(id: UUID(), author: mf, text: "AWESOME", date: Date(), likes: 0),
            Comment(id: UUID(), author: mf, text: "not bad", date: Date(), likes: 0),
            Comment(id: UUID(), author: mf, text: "PUTIN!!11!!", date: Date(), likes: 1000),
        ]
        let mfPosts: [Post] = [
            Post(id: UUID(), author: mf, photo: "color_study", description: "Kandinskiy", date: Date(), likes: 5, comments: mfComments.sorted(by: {$0.text < $1.text})),
            Post(id: UUID(), author: mf, photo: "starry_night", description: "Van Gog", date: Date(), likes: 2, comments: mfComments.sorted(by: {$0.text > $1.text})),
            Post(id: UUID(), author: mf, photo: "tomato_soup", description: "TOMAAATOOO", date: Date(), likes: 10, comments: mfComments.sorted(by: {$0.likes > $1.likes})),
            Post(id: UUID(), author: mf, photo: "dali", description: "licking time", date: Date(), likes: 100000, comments: mfComments.sorted(by: {$0.likes > $1.likes})),
            Post(id: UUID(), author: mf, photo: "picasso", description: "pcs", date: Date(), likes: 0, comments: mfComments.sorted(by: {$0.likes < $1.likes})),
        ]
        let torburg = User(id: mf.id, avatar: mf.avatar, name: mf.name, email: mf.email, password: mf.password, followers: mf.followers, following: mf.following, posts: mfPosts)
        
        let sl = User(id: UUID(), avatar: "slavatar", name: "sofya", email: "lapuloh@yandex.ru", password: "snya123", followers: 103, following: 515, posts: nil)
        let slComments: [Comment] = [
            Comment(id: UUID(), author: mf, text: "AWESOME", date: Date(), likes: 0),
            Comment(id: UUID(), author: mf, text: "fffffff", date: Date(), likes: 0),
            Comment(id: UUID(), author: sl, text: "LUKASHENKO!!11!!", date: Date(), likes: 1000),
        ]
        let slPosts: [Post] = [
            Post(id: UUID(), author: sl, photo: "sl1", description: "С одной стороны и тут норм, но надо ремонт сделать. А мне неочень хочется. Потому что и так уже тут много вложились в ремонт на кухне, дверь входную поставили, и так по мелочам...", date: Date(), likes: 50, comments: mfComments.sorted(by: {$0.text < $1.text})),
            Post(id: UUID(), author: sl, photo: "sl2", description: "Про волосы, кстати, я имела в виду цвет", date: Date(), likes: 0, comments: slComments.sorted(by: {$0.text > $1.text})),
        ]
        let sofya = User(id: sl.id, avatar: sl.avatar, name: sl.name, email: sl.email, password: sl.password, followers: sl.followers, following: sl.following, posts: slPosts)
        
        
        var slLikedPosts = mfPosts.filter{ $0.description == "licking time" || $0.description == "Van Gog" }
        slLikedPosts.append(slPosts.first!)
        
        let mfLikedPosts = slPosts
        likedPosts = [
            "torburg_max": mfLikedPosts,
            "sofya": slLikedPosts
        ]
        
        return [torburg, sofya]
    }
    
    enum Like {
        case liked
        case unliked
    }
}