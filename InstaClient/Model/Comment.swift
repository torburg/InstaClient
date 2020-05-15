//
//  Comment.swift
//  InstaClient
//
//  Created by Maksim Torburg on 15.05.2020.
//  Copyright © 2020 Maksim Torburg. All rights reserved.
//

import Foundation

struct Comment {
    let author: User
    let text: String
    let date: Date
    let likes: Int
}
