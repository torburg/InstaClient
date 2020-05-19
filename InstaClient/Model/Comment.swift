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
    
    init() {
        author = User()
        text = ""
        date = Date()
        likes = 0
    }
    
    init(author: User, text: String, date: Date, likes: Int) {
        self.author = author
        self.text = text
        self.date = date
        self.likes = likes
    }
}
