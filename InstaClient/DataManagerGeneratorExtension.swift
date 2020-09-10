//
//  DataManagerGeneratorExtension.swift
//  InstaClient
//
//  Created by Maksim Torburg on 14.06.2020.
//  Copyright © 2020 Maksim Torburg. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension DataManager {
    func generateData() {
        
        let torburg: User = {
            let user = User(context: viewContext)
            user.avatar = UIImage(named: "a_mf")
            user.name = "torburg_max"
            user.email = "torburg@yandex.ru"
            user.password = "max123"
            user.followers = 0
            user.following = 5
            user.posts = nil
            return user
        }()
        
        let kandinskiyPost: Post = {
            let post = Post(context: viewContext); post.author = torburg; post.photo = UIImage(named: "color_study"); post.content = "Kandinskiy"; post.date = Date(); post.likes = 5;
            return post
        }()
        let vanGogPost: Post = {
            let post = Post(context: viewContext); post.author = torburg; post.photo = UIImage(named: "starry_night"); post.content = "Van Gog"; post.date = Date(); post.likes = 2;
            return post
        }()
        let tomatooPost: Post = {
            let post = Post(context: viewContext); post.author = torburg; post.photo = UIImage(named: "tomato_soup"); post.content = "TOMAAATOOO"; post.date = Date(); post.likes = 10;
            return post
        }()
        let picassoPost: Post = {
            let post = Post(context: viewContext); post.author = torburg; post.photo = UIImage(named: "picasso"); post.content = "pcs"; post.date = Date(); post.likes = 0;
            return post
        }()
        let daliPost: Post = {
            let post = Post(context: viewContext); post.author = torburg; post.photo = UIImage(named: "dali"); post.content = "licking time"; post.date = Date(); post.likes = 10000;
            return post
        }()
        
        let awesomeComment: Comment = {
            let comment = Comment(context: viewContext); comment.author = torburg; comment.text = "AWESOME"; comment.date = Date(); comment.likes = 0; comment.post = kandinskiyPost
            return comment
        }()
        let notBadComment: Comment = {
            let comment = Comment(context: viewContext); comment.author = torburg; comment.text = "not bad"; comment.date = Date(); comment.likes = 0; comment.post = vanGogPost
            return comment
        }()
        let putinComment: Comment = {
            let comment = Comment(context: viewContext); comment.author = torburg; comment.text = "PUTIN!!11!!"; comment.date = Date(); comment.likes = 1000; comment.post = daliPost
            return comment
        }()
        
        var torburgComments: [Comment] = {
            return [awesomeComment, notBadComment, putinComment]
        }()

        torburgComments.sort { $0.likes > $1.likes }
        kandinskiyPost.addToComments(NSSet(array: torburgComments))

        torburg.addToPosts(kandinskiyPost)
        torburg.addToPosts(vanGogPost)
        torburg.addToPosts(tomatooPost)
        torburg.addToPosts(picassoPost)
        torburg.addToPosts(daliPost)
        
        let sofya: User = {
           let user = User(context: viewContext)
           user.avatar = UIImage(named: "slavatar")
           user.name = "sofya"
           user.email = "lapuloh@yandex.ru"
           user.password = "snya123"
           user.followers = 103
           user.following = 515
           user.posts = nil
           return user
        }()
        
        let sl1Post: Post = {
            let post = Post(context: viewContext); post.author = sofya; post.photo = UIImage(named: "sl1"); post.content = "С одной стороны и тут норм, но надо ремонт сделать. А мне неочень хочется. Потому что и так уже тут много вложились в ремонт на кухне, дверь входную поставили, и так по мелочам..."; post.date = Date(); post.likes = 50;
            return post
        }()
        let sl2Post: Post = {
            let post = Post(context: viewContext); post.author = sofya; post.photo = UIImage(named: "sl2"); post.content = "Про волосы, кстати, я имела в виду цвет"; post.date = Date(); post.likes = 0;
            return post
        }()
        let sl3Post: Post = {
            let post = Post(context: viewContext); post.author = sofya; post.photo = UIImage(named: "sl3"); post.content = "Потому что ботокс колят, он всю мимику нахрен убивает"; post.date = Date(); post.likes = 1;
            return post
        }()
        let sl4Post: Post = {
            let post = Post(context: viewContext); post.author = sofya; post.photo = UIImage(named: "sl4"); post.content = "Сон снился"; post.date = Date(); post.likes = 50;
            return post
        }()
        
        let _: Comment = {
            let comment = Comment(context: viewContext); comment.author = torburg; comment.text = "AWESOME"; comment.date = Date(); comment.likes = 0; comment.post = sl1Post
            return comment
        }()
        let _: Comment = {
            let comment = Comment(context: viewContext); comment.author = torburg; comment.text = "fffffff"; comment.date = Date(); comment.likes = 0; comment.post = sl2Post
            return comment
        }()
        let _: Comment = {
            let comment = Comment(context: viewContext); comment.author = torburg; comment.text = "LUKASHENKO!!11!!"; comment.date = Date(); comment.likes = 1000; comment.post = sl3Post
            return comment
        }()
//        let slComments: [Comment] = {
//            return [slAwesomeComment, slffffComment, slLukashenkoComment]
//        }()
        
        sofya.addToPosts(sl1Post)
        sofya.addToPosts(sl2Post)
        sofya.addToPosts(sl3Post)
        sofya.addToPosts(sl4Post)
        
        saveContext()
        
//        return [torburg, sofya]
    }
}
