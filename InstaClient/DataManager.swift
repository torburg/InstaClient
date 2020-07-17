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
    func getAllUsers() -> [User]?
    
    func syncGetUser(by name: String) -> User?
    
    func asyncGetUser(by name: String, completion: (User)->Void)
    
    func syncGetPost(of user: User, for indexPath: IndexPath) -> Post?
    
    func asyncGetPost(of user: User, for indexPath: IndexPath, completion: @escaping (Post)->Void)
    
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
    
//    private var mainUser: User = {
//        let fetchRequest: NSFetchRequest = User.fetchRequest()
//        let name = "sofya"
//        let predicate = NSPredicate(format: "name == #@", name)
//        fetchRequest.predicate = predicate
//        var users: [User] = []
//        do {
//            users = try fetchRequest.execute()
//        } catch let error {
//            print(error)
//        }
//        return users.first!
//    }()
    
    static let shared = DataManager()
    
    lazy var userFetchResultController: NSFetchedResultsController<User> = {
        let fetchRequest: NSFetchRequest = User.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(User.name), ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchResultsController
    }()
    
    lazy var postsFetchResultController: NSFetchedResultsController<Post> = {
        let fetchRequest: NSFetchRequest = Post.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(Post.date), ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchResultsController
    }()
    
    let savingQueue = DispatchQueue(label: "net.torburg.saving", qos: .default)
    let fetchingQueue = DispatchQueue(label: "net.torburg.fetching", qos: .default)
    let fetchQueue = DispatchQueue(label: "net.torburg.fetch", qos: .default, attributes: .concurrent, autoreleaseFrequency: .never, target: nil)
    
//    private var users: [User] = []
    
    
    // TODO: - Add liked Posts
//    private var likedPosts: [Post]? = nil
    
    private var userDefaults = UserDefaults.standard
    
    init() {
        load { (result) in
            switch result {
            case .failure:
                self.generateData()
            case .success:
                print("Success")
            }
        }
    }

    func getAllUsers() -> [User]? {
        return userFetchResultController.fetchedObjects
    }
    
// `   func getMainUser() -> User {
//        return mainUser
//    }`
    
    func syncGetUser(by name: String) -> User? {
        let predicate = NSPredicate(format: "name == %@", name)
        userFetchResultController.fetchRequest.predicate = predicate
        do {
            try userFetchResultController.performFetch()
        } catch let error {
            print(error)
        }
        return userFetchResultController.fetchedObjects?.first
    }

    private func getAllPosts(of user: User) -> [Post]? {
        let predicate = NSPredicate(format: "author == %@", user)
        postsFetchResultController.fetchRequest.predicate = predicate
        do {
            try postsFetchResultController.performFetch()
        } catch let error {
            print(error)
        }
        return postsFetchResultController.fetchedObjects
    }
    
    func syncGetPost(of user: User, for indexPath: IndexPath) -> Post? {
        let predicate = NSPredicate(format: "author == %@", user)
        postsFetchResultController.fetchRequest.predicate = predicate
        do {
            try postsFetchResultController.performFetch()
        } catch let error {
            print(error)
        }
        let post = postsFetchResultController.object(at: indexPath)
        return post
    }
    
    func asyncGetPost(of user: User, for indexPath: IndexPath, completion: @escaping (Post)->Void) {
        let predicate = NSPredicate(format: "author == %@", user)
        postsFetchResultController.fetchRequest.predicate = predicate
        do {
            try postsFetchResultController.performFetch()
        } catch let error {
            print(error)
        }
        let post = postsFetchResultController.object(at: indexPath)
        completion(post)
    }
    
    func asyncGetUser(by name: String, completion: (User)->Void) {
        let predicate = NSPredicate(format: "name == %@", name)
        userFetchResultController.fetchRequest.predicate = predicate
        guard let user = userFetchResultController.fetchedObjects?.first else { return }
        completion(user)
    }
    
    func postCount(for user: User) -> Int? {
        let predicate = NSPredicate(format: "author == %@", user)
        postsFetchResultController.fetchRequest.predicate = predicate
        do {
            try postsFetchResultController.performFetch()
        } catch let error {
            print(error)
        }
        return postsFetchResultController.fetchedObjects?.count
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
    
    func load(completion: @escaping (FetchResult)->()) {
        do {
            try userFetchResultController.performFetch()
            completion(.success)
        } catch let error {
            print(error)
            completion(.failure)
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

enum FetchResult {
    case success
    case failure
}


