//
//  TabBarRouter.swift
//  InstaClient
//
//  Created by Maksim Torburg on 15.09.2020.
//  Copyright © 2020 Maksim Torburg. All rights reserved.
//

import Foundation
import UIKit

protocol TabBarRouterProtocol {
    var currentViewController: UIViewController? { get set }
    init(currentViewController: UIViewController)
    func goToHomeScreen()
    func goToSearchScreen()
    func goToAddPostScreen()
    func goToLikesScreen()
    func goToProfileScreen()
}

final class TabBarRouter: TabBarRouterProtocol {
    
    weak var currentViewController: UIViewController?
    weak var navigationViewController: UINavigationController?
    
    init(currentViewController: UIViewController) {
        self.currentViewController = currentViewController
    }
    
    func goToAddPostScreen() {
        print(#function)
    }
    
    func goToLikesScreen() {
        print(#function)
    }
    
    func goToProfileScreen() {
        print(#function)
        let profileViewController = ModuleBuilder.createProfileViewController(root: nil)
        navigationViewController?.viewControllers.removeAll()
        navigationViewController?.pushViewController(profileViewController, animated: true)
        currentViewController = profileViewController
    }
    
    func goToHomeScreen() {
        print(#function)
    }
    
    func goToSearchScreen() {
        print(#function)
        currentViewController = nil
        let searchViewController = ModuleBuilder.createSearchViewController()
        navigationViewController?.viewControllers.removeAll()
        navigationViewController?.pushViewController(searchViewController, animated: true)
        currentViewController = searchViewController
    }
}
