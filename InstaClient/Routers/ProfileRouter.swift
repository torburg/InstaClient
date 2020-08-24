//
//  ProfileRouter.swift
//  InstaClient
//
//  Created by Maksim Torburg on 24.08.2020.
//  Copyright © 2020 Maksim Torburg. All rights reserved.
//

import Foundation
import UIKit

final class ProfileRouter {
    
    private weak var rootViewController: UIViewController!
    
    func root(_ window: inout UIWindow?) {
        let frame = UIScreen.main.bounds
        window = UIWindow(frame: frame)
        window?.makeKeyAndVisible()
        
        let vc = ProfileViewController()
        
        window?.rootViewController = UINavigationController(rootViewController: vc)
    }
    
    convenience init(rootViewController: UIViewController) {
        self.init()
        self.rootViewController = rootViewController
    }
    
    func goToPostsList(to currentPost: Post) {
        guard let postsListVC = rootViewController.storyboard?.instantiateViewController(identifier: "postListView") else { return }
        guard let vc = postsListVC as? PostsListViewController else { return }
        vc.currentPost = currentPost
        rootViewController.navigationController?.pushViewController(vc, animated: false)
    }
}