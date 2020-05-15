//
//  Post.swift
//  InstaClient
//
//  Created by Maksim Torburg on 15.05.2020.
//  Copyright © 2020 Maksim Torburg. All rights reserved.
//

import Foundation

struct Post {
    let author: User
    let photo: String
    let description: String?
    let date: Date
    let likes: Int?
    let comments: [Comment]?
}
