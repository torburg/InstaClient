//
//  DataManager.swift
//  InstaClient
//
//  Created by Maksim Torburg on 16.05.2020.
//  Copyright © 2020 Maksim Torburg. All rights reserved.
//

import Foundation
import CoreData

protocol DataManagerProtocol {
    func getAllUsers() -> [User]
    
    func syncGetUser(by name: String) -> User?
    
    func asyncGetUser(by name: String, completion: (User)->Void)
    
    func syncGetPost(of user: User, for index: Int) -> Post?
    
    func asyncGetPost(of user: User, for index: Int, completion: @escaping (Post)->Void)
    
    func getIndex(of post: Post, of user: User) -> Int?
    
    func asyncDeletePost(of user: User, by index: Int, completion: @escaping (Response)->Void)
    
//    func getAllLikedPosts() -> [String : [Post]]?
    
//    func getLikedPosts(of user: User) -> [Post]?
    
//    func updateLikedPosts(with posts: [Post], of user: User)
}

class DataManager: DataManagerProtocol {
    
    private enum UserDefaultsStorage {
        static let users      = "users"
        static let likedPosts = "likedPosts"
    }
    
    static let shared = DataManager()
    
    let savingQueue = DispatchQueue(label: "net.torburg.saving", qos: .default)
    let fetchingQueue = DispatchQueue(label: "net.torburg.fetching", qos: .default)
    let fetchQueue = DispatchQueue(label: "net.torburg.fetch", qos: .default, attributes: .concurrent, autoreleaseFrequency: .never, target: nil)
    
    private var users: [User] = []
    
    
    // TODO: - Add liked Posts
    private var likedPosts: [Post]? = nil
    
    private var userDefaults = UserDefaults.standard
    
    init() {
        load()
        if users.isEmpty {
            users = self.generateData()
        }
    }

    func getAllUsers() -> [User] {
        return users
    }
    
    func syncGetUser(by name: String) -> User? {
        return users.filter{ $0.name == name}.first
    }

    private func getAllPosts(of user: User) -> [Post]? {
//        return syncGetUser(by: user.name)?.posts
        return nil
    }
    
    func syncGetPost(of user: User, for index: Int) -> Post? {
        guard let posts = getAllPosts(of: user) else { return nil }
        let post = posts[index]
        return post
    }
    
    func asyncGetPost(of user: User, for index: Int, completion: @escaping (Post)->Void) {
        
        // FIXME: - CoreData Fetching
//        fetchingQueue.asyncAfter(deadline: .now()) { [weak self] in
//            guard let manager = self else { return }
//            guard let posts = manager.users.filter({ $0 == user }).first?.posts else { return }
//            let post = posts.dropFirst(index)
//            DispatchQueue.main.async {
//                completion(post)
//            }
//        }
    }
    
    func asyncGetUser(by name: String, completion: (User)->Void) {
        // FIXME: - CoreData Fetching
        guard let user = users.first(where: { $0.name == name } ) else { return }
        completion(user)
    }
    
    func postCount(for user: User) -> Int {
        return users.filter({ $0 == user }).first?.posts?.count ?? 0
    }
    
    func getIndex(of post: Post, of user: User) -> Int? {
        guard let posts = getAllPosts(of: user) else { return nil }
        return posts.firstIndex(where: { $0 == post })
    }
    
    // FIXME: - CoreData Fetching
    func asyncDeletePost(of user: User, by index: Int, completion: @escaping (Response)->Void) {
//        savingQueue.async { [weak self] in
//            guard let manager = self else { completion(Response.error); return }
//            guard let posts = manager.getAllPosts(of: user) else { completion(Response.error); return }
//            let postToDelete = posts[index]
//            let postsWithoutDeleted = user.posts?.filter{ $0 != postToDelete }
//            let replacingUser = User(id: user.id, avatar: user.avatar, name: user.name, email: user.email, password: user.password, followers: user.followers, following: user.following, posts: postsWithoutDeleted)
//            manager.users.removeAll(where: { $0 == user })
//            manager.users.append(replacingUser)
//            manager.save()
//        }
//        DispatchQueue.main.async {
//            completion(Response.success)
//        }
    }
    
    // FIXME: - CoreData Fetching
    func filterPosts(of user: User, contains text: String, completion: @escaping ([Post])->Void) {
        guard let allPosts = getAllPosts(of: user) else { completion([]); return }
//        let filtredPosts = allPosts.filter({ $0.description?.lowercased().contains(text.lowercased()) ?? false })
        completion(allPosts)
    }
    
    func save() {
        // MARK: - Don't forget save liked post??
        do {
            try viewContext.save()
        } catch let error {
            print("Unable to save viewContext: \(error)")
        }
    }
    
    func load() {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        do {
            users = try viewContext.fetch(fetchRequest)
        } catch let error {
            print(error)
        }
    }
    
    // MARK: - CoreData
    
    lazy var viewContext = persistentContainer.viewContext

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "InstaClient")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

enum Response {
    case success
    case error
}
