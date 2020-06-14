//
//  Comment+CoreDataProperties.swift
//  InstaClient
//
//  Created by Maksim Torburg on 12.06.2020.
//  Copyright © 2020 Maksim Torburg. All rights reserved.
//
//

import Foundation
import CoreData


extension Comment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Comment> {
        return NSFetchRequest<Comment>(entityName: "Comment")
    }

    @NSManaged public var date: Date
    @NSManaged public var likes: Int16
    @NSManaged public var text: String
    @NSManaged public var author: User
    @NSManaged public var post: Post

}
