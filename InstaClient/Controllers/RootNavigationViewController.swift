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

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
    }
    
    func configureTabBar() {
        let home = UIButton()
        let homeImage = UIImage(named: "homeUnchosen")
        home.setImage(homeImage, for: .normal)
        let homeTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(homeTapped))
        home.addGestureRecognizer(homeTapRecognizer)
        tabBarView.addArrangedSubview(home)

        let search = UIButton()
        let searchImage = UIImage(named: "SearchUnchosen")
        let searchTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(searchTapped))
        search.addGestureRecognizer(searchTapRecognizer)
        search.setImage(searchImage, for: .normal)
        tabBarView.addArrangedSubview(search)
        
        let newPost = UIButton()
        let newPostImage = UIImage(named: "AddUnchosen")
        let newPostTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(newPostTapped))
        newPost.addGestureRecognizer(newPostTapRecognizer)
        newPost.setImage(newPostImage, for: .normal)
        tabBarView.addArrangedSubview(newPost)

        let likes = UIButton()
        let likesImage = UIImage(named: "LikeUnchosen")
        let likesTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(likesTapped))
        likes.addGestureRecognizer(likesTapRecognizer)
        likes.setImage(likesImage, for: .normal)
        tabBarView.addArrangedSubview(likes)

        let profile = UIButton()
        let profileImage = UIImage(named: "ProfileUnchosen")
        let profileTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileTapped))
        profile.addGestureRecognizer(profileTapRecognizer)
        profile.setImage(profileImage, for: .normal)
        tabBarView.addArrangedSubview(profile)
        
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
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    convenience init(rootViewController: UIViewController, router: TabBarRouterProtocol) {
        self.init(rootViewController: rootViewController)
        self.router = router
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RootNavigationViewController {
    @objc
    func homeTapped() {
        router.goToHomeScreen()
    }

    @objc
    func searchTapped() {
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
        router.goToProfileScreen()
    }
}
