//
//  TabBarRouter.swift
//  InstaClient
//
//  Created by Maksim Torburg on 15.09.2020.
//  Copyright © 2020 Maksim Torburg. All rights reserved.
//

import Foundation

protocol TabBarRouterProtocol {
    func goToHomeScreen()
    func goToSearchScreen()
    func goToAddPostScreen()
    func goToLikesScreen()
    func goToProfileScreen()
}

class TabBarRouter: TabBarRouterProtocol {
    func goToAddPostScreen() {
        print(#function)
    }
    
    func goToLikesScreen() {
        print(#function)
    }
    
    func goToProfileScreen() {
        print(#function)
    }
    
    func goToHomeScreen() {
        print(#function)
    }
    
    func goToSearchScreen() {
        print(#function)
    }
}
