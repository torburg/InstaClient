//
//  RootNavigationViewController.swift
//  InstaClient
//
//  Created by Maksim Torburg on 15.09.2020.
//  Copyright © 2020 Maksim Torburg. All rights reserved.
//

import UIKit

class RootNavigationViewController: UINavigationController {
    
    var router: TabBarRouterProtocol!
    let tabBarHeight = CGFloat(85.0)
    let tabBarView: UIStackView = {
        let tabBarView = UIStackView()
        tabBarView.axis = .horizontal
        tabBarView.distribution = .fillEqually
        
        return tabBarView
    }()
    
    var homeButton: UIButton?
    var searchButton: UIButton?
    var addPostButton: UIButton?
    var likeButton: UIButton?
    var profileButton: UIButton?
    
    private func createButton(named imageName: String) -> UIButton {
        let button = UIButton()
        let image = UIImage(chosen: false, named: imageName)
        let imageSelected = UIImage(chosen: true, named: imageName)
        button.setImage(image, for: .disabled)
        button.setImage(imageSelected, for: .selected)
        return button
    }
    
    func setState() {
        for view in tabBarView.arrangedSubviews {
            if let button = view as? UIButton {
                button.isEnabled = true
                button.isSelected = false
                let currentViewController = router.currentViewController
                if let _ = currentViewController as? SearchViewController {
                    searchButton?.isEnabled = false
//                    searchButton?.isEnabled = false
                    searchButton?.removeTarget(self, action: #selector(searchTapped), for: .touchUpInside)
                    break
                } else if let _ = currentViewController as? ProfileViewController {
                    profileButton?.isEnabled = false
//                    profileButton?.removeTarget(self, action: #selector(profileTapped), for: .touchUpInside)
                    break
                }
            }
        }
    }
    
    func removeGestureRecognizers(from uibutton: UIButton?) {
        guard let button = uibutton, let gestureRecognizers = button.gestureRecognizers else { return }
        for gestureRecognizer in gestureRecognizers {
            button.removeGestureRecognizer(gestureRecognizer)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        setState()
    }
    
    func configureTabBar() {
        homeButton = createButton(named: "Home")
        guard homeButton != nil else { return }
        
        tabBarView.addArrangedSubview(homeButton!)
        
        searchButton = createButton(named: "Search")
        guard searchButton != nil else { return }
//        let searchGestureRecognizer = UIGestureRecognizer(target: self, action: #selector(searchTapped))
//        searchButton!.addGestureRecognizer(searchGestureRecognizer)
        searchButton?.addTarget(self, action: #selector(searchTapped), for: .touchUpInside)
        tabBarView.addArrangedSubview(searchButton!)
        
        addPostButton = createButton(named: "Add")
        guard addPostButton != nil else { return }
        tabBarView.addArrangedSubview(addPostButton!)
        
        likeButton = createButton(named: "Like")
        guard likeButton != nil else { return }
        tabBarView.addArrangedSubview(likeButton!)
        
        profileButton = createButton(named: "Profile")
        guard profileButton != nil else { return }
        profileButton!.addTarget(self, action: #selector(profileTapped), for: .touchUpInside)
//        let profileGestureRecognizer = UIGestureRecognizer(target: self, action: #selector(profileTapped))
//        profileButton!.addGestureRecognizer(profileGestureRecognizer)
        tabBarView.addArrangedSubview(profileButton!)
        
        tabBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tabBarView)
        let constraints = [
            tabBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tabBarView.heightAnchor.constraint(equalToConstant: tabBarHeight),
        ]
        NSLayoutConstraint.activate(constraints)
        // FIXME: - Change backgroundColor to backgroundColor of basicView
        tabBarView.subviews.forEach{ $0.backgroundColor = .white }
              
    }
    
    init(rootViewController: UIViewController, router: TabBarRouterProtocol) {
        self.router = router
        super.init(rootViewController: rootViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RootNavigationViewController {
    @objc
    func homeTapped() {
        router.goToHomeScreen()
        setState()
    }

    @objc
    func searchTapped() {
        print(#function)
        router.goToSearchScreen()
    }
    
    @objc
    func newPostTapped() {
        router.goToAddPostScreen()
    }
    
    @objc
    func likesTapped() {
        router.goToLikesScreen()
    }
    
    @objc
    func profileTapped() {
        print(#function)
        router.goToProfileScreen()
        setState()
    }
}
