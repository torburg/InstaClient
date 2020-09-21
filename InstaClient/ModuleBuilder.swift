//
//  ModuleBuilder.swift
//  InstaClient
//
//  Created by Maksim Torburg on 27.08.2020.
//  Copyright © 2020 Maksim Torburg. All rights reserved.
//

import UIKit

protocol ModuleBuilderProtocol {
    static func createProfileViewController(root rootViewController: UIViewController?) -> ProfileViewController
    static func createPostsListViewController(_ currentPost: Post) -> PostsListViewController
}

class ModuleBuilder: ModuleBuilderProtocol {
    
    static let dataManager = DataManager()
    
    static func createProfileViewController(root rootViewController: UIViewController?) -> ProfileViewController {
        let profileRouter = ProfileRouter()
        let profileViewController = ProfileViewController()
        let profilePresenter = ProfilePresenter(view: profileViewController, dataManager: dataManager, router: profileRouter)
        profileRouter.setRootViewController(profileViewController)
        profileViewController.presenter = profilePresenter
        return profileViewController
    }
    
    static func createPostsListViewController(_ currentPost: Post) -> PostsListViewController {
        let postListViewController = PostsListViewController()
        let profileRouter = ProfileRouter()
        let postsListPresenter = PostsListPresenter(view: postListViewController, dataManager: dataManager, router: profileRouter)
        postsListPresenter.currentPost = currentPost
        postListViewController.presenter = postsListPresenter
        return postListViewController
    }
    
    static func createNavigationController(_ rootViewController: UIViewController) -> UINavigationController {
        let tabBarRouter = TabBarRouter(currentViewController: rootViewController)
        let navigationController = RootNavigationViewController(rootViewController: rootViewController, router: tabBarRouter)
        tabBarRouter.navigationViewController = navigationController
        return navigationController
    }
    
    static func createSearchViewController() -> SearchViewController {
        let searchViewController = SearchViewController()
        let searchViewRouter = SearchViewRouter()
        let searchViewPresenter = SearchPresenter(view: searchViewController, dataManager: dataManager, router: searchViewRouter)
        searchViewController.presenter = searchViewPresenter
        return searchViewController
    }
}
