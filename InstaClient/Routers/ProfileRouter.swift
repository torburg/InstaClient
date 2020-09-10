//
//  ProfileRouter.swift
//  InstaClient
//
//  Created by Maksim Torburg on 24.08.2020.
//  Copyright © 2020 Maksim Torburg. All rights reserved.
//

import Foundation
import UIKit

protocol ProfileRouterProtocol {
    init(rootViewController: UIViewController)
    func goToPostsList(to currentPost: Post)
}

final class ProfileRouter: ProfileRouterProtocol {
    
    private weak var rootViewController: UIViewController!
    
    func setRootViewController(_ rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    convenience init(rootViewController: UIViewController) {
        self.init()
        self.rootViewController = rootViewController
    }
    
    func goToPostsList(to currentPost: Post) {
        let postsListVC = ModuleBuilder.createPostsListViewController(currentPost)
        rootViewController.navigationController?.pushViewController(postsListVC, animated: false)
    }
}
