//
//  Post+CoreDataProperties.swift
//  InstaClient
//
//  Created by Maksim Torburg on 12.06.2020.
//  Copyright © 2020 Maksim Torburg. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var content: String?
    @NSManaged public var date: Date?
    @NSManaged public var likes: Int16
    @NSManaged public var photo: UIImage?
    @NSManaged public var author: User
    @NSManaged public var comments: NSSet?

}

// MARK: Generated accessors for comments
extension Post {

    @objc(addCommentsObject:)
    @NSManaged public func addToComments(_ value: Comment)

    @objc(removeCommentsObject:)
    @NSManaged public func removeFromComments(_ value: Comment)

    @objc(addComments:)
    @NSManaged public func addToComments(_ values: NSSet)

    @objc(removeComments:)
    @NSManaged public func removeFromComments(_ values: NSSet)

}
