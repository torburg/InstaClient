//
//  User+CoreDataProperties.swift
//  InstaClient
//
//  Created by Maksim Torburg on 12.06.2020.
//  Copyright © 2020 Maksim Torburg. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var avatar: UIImage?
    @NSManaged public var email: String
    @NSManaged public var followers: Int16
    @NSManaged public var following: Int16
    @NSManaged public var name: String
    @NSManaged public var password: String
    @NSManaged public var comments: NSSet?
    @NSManaged public var posts: NSSet?

}

// MARK: Generated accessors for comments
extension User {

    @objc(addCommentsObject:)
    @NSManaged public func addToComments(_ value: Comment)

    @objc(removeCommentsObject:)
    @NSManaged public func removeFromComments(_ value: Comment)

    @objc(addComments:)
    @NSManaged public func addToComments(_ values: NSSet)

    @objc(removeComments:)
    @NSManaged public func removeFromComments(_ values: NSSet)

}

// MARK: Generated accessors for posts
extension User {

    @objc(addPostsObject:)
    @NSManaged public func addToPosts(_ value: Post)

    @objc(removePostsObject:)
    @NSManaged public func removeFromPosts(_ value: Post)

    @objc(addPosts:)
    @NSManaged public func addToPosts(_ values: NSSet)

    @objc(removePosts:)
    @NSManaged public func removeFromPosts(_ values: NSSet)

}
