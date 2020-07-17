//
//  ProfileViewControllerrViewController.swift
//  InstaClient
//
//  Created by Maksim Torburg on 14.05.2020.
//  Copyright © 2020 Maksim Torburg. All rights reserved.
//

import UIKit
import CoreData

class ProfileViewControllerrViewController: UIViewController {
    
    // MARK: - Properties
    var user: User? = nil
//    var userFetchReslutController: NSFetchedResultsController<User>!
//    var postFetchReslutController: NSFetchedResultsController<Post>!

    @IBOutlet weak var numberOfPosts: UILabel!
    @IBOutlet weak var numberOfFollowers: UILabel!
    @IBOutlet weak var numberOfFollowing: UILabel!
    
    @IBOutlet weak var gallery: UICollectionView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    
    private let minimumSpacing: CGFloat = 3.0
    private let maxItemsInLine = 3
    lazy private var dataManager = DataManager.shared
    
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        getData()
    }

    func setupView() {
        avatar.layer.cornerRadius = avatar.frame.width / 2
        
        editButton.layer.cornerRadius = 5
        editButton.layer.borderWidth = 1
        editButton.layer.borderColor = UIColor(red: 0.859, green: 0.859, blue: 0.859, alpha: 1).cgColor
        
        gallery.register(GalleryViewCell.self, forCellWithReuseIdentifier: GalleryViewCell.reuseID)
        
        navigationController?.navigationBar.backgroundColor = view.backgroundColor
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
        navigationController?.navigationBar.backIndicatorImage?.withTintColor(.black)
        navigationController?.navigationBar.backIndicatorTransitionMaskImage?.withTintColor(.black)

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
    }
    
    func getData() {
//        guard let name = UserDefaults.standard.value(forKey: "UserName") as? String else { return }
        let name = "sofya"
        guard let user = dataManager.syncGetUser(by: name) else { return }
            self.user = user
            navigationItem.title = user.name
            let postCount = user.posts?.count ?? 0
            self.numberOfPosts.text = String(postCount)
            let followers = user.followers
            self.numberOfFollowers.text = String(followers)
            let following = user.following
            self.numberOfFollowing.text = String(following)

            guard let avatarImage = user.avatar else { return }
            self.avatar.image = avatarImage
            self.avatar.contentMode = .scaleAspectFill
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // FIXME: - When cell is only one it's located in the center of line
        super.viewWillAppear(animated)
        getData()
        gallery.reloadData()
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension ProfileViewControllerrViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let currentUser = user else { return 0 }
        return dataManager.postCount(for: currentUser) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dequedCell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryViewCell.reuseID, for: indexPath)
        guard let cell = dequedCell as? GalleryViewCell else { return dequedCell}
        cell.user = user
        cell.onBind(for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let currentUser = user else { return }
        guard let postsListVC = storyboard?.instantiateViewController(identifier: "postListView") else { return }
        guard let vc = postsListVC as? PostsListViewController else { return }
        vc.currentPost = dataManager.syncGetPost(of: currentUser, for: indexPath)
        navigationController?.pushViewController(vc, animated: false)
        // FIXME: - Do I need this?..
//            self.performSegue(withIdentifier: "showPost", sender: nil)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProfileViewControllerrViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let fullWidth = collectionView.bounds.width
        let availableWidth = fullWidth - CGFloat(maxItemsInLine - 1) * minimumSpacing
        let widthOfItem = availableWidth / CGFloat(maxItemsInLine)
        return CGSize(width: widthOfItem, height: widthOfItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumSpacing
    }

}

