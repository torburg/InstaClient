//
//  User.swift
//  InstaClient
//
//  Created by Maksim Torburg on 15.05.2020.
//  Copyright © 2020 Maksim Torburg. All rights reserved.
//

import Foundation

struct User {
    let avatar: String?
    let name: String
    let email: String
    let password: String
    let followers: Int?
    let following: Int?
    let posts: [Post]?
    
    init() {
        avatar = ""
        name = ""
        email = ""
        password = ""
        followers = 0
        following = 0
        posts = []
    }
    
    
    init(avatar: String?, name: String, email: String, password: String, followers: Int?, following: Int?, posts: [Post]?) {
        self.avatar = avatar
        self.name = name
        self.email = email
        self.password = password
        self.followers = followers
        self.following = following
        self.posts = posts
    }
}
