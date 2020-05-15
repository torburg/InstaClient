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
}
