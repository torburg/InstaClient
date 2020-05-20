//
//  User.swift
//  InstaClient
//
//  Created by Maksim Torburg on 15.05.2020.
//  Copyright © 2020 Maksim Torburg. All rights reserved.
//

import Foundation

struct User {
    let id: UUID
    let avatar: String?
    let name: String
    let email: String
    let password: String
    let followers: Int?
    let following: Int?
    let posts: [Post]?
    
    init() {
        id = UUID()
        avatar = ""
        name = ""
        email = ""
        password = ""
        followers = 0
        following = 0
        posts = []
    }
    
    
    init(id: UUID, avatar: String?, name: String, email: String, password: String, followers: Int?, following: Int?, posts: [Post]?) {
        self.id = id
        self.avatar = avatar
        self.name = name
        self.email = email
        self.password = password
        self.followers = followers
        self.following = following
        self.posts = posts
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func != (lhs: User, rhs: User) -> Bool {
        return !(lhs == rhs)
    }
}
