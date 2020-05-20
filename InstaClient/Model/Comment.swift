//
//  Comment.swift
//  InstaClient
//
//  Created by Maksim Torburg on 15.05.2020.
//  Copyright © 2020 Maksim Torburg. All rights reserved.
//

import Foundation

struct Comment {
    let id: UUID
    let author: User
    let text: String
    let date: Date
    let likes: Int
    
    init() {
        id = UUID()
        author = User()
        text = ""
        date = Date()
        likes = 0
    }
    
    init(id: UUID, author: User, text: String, date: Date, likes: Int) {
        self.id = id
        self.author = author
        self.text = text
        self.date = date
        self.likes = likes
    }
}
