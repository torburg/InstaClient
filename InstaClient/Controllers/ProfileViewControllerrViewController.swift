//
//  ProfileViewControllerrViewController.swift
//  InstaClient
//
//  Created by Maksim Torburg on 14.05.2020.
//  Copyright © 2020 Maksim Torburg. All rights reserved.
//

import UIKit

class ProfileViewControllerrViewController: UIViewController {

    @IBOutlet weak var numberOfPosts: UILabel!
    @IBOutlet weak var numberOfFollowers: UILabel!
    @IBOutlet weak var numberOfFollowing: UILabel!
    
    @IBOutlet weak var gallery: UICollectionView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    
    private let minimumSpacing: CGFloat = 3.0
    private let imagesCount = 6
    private let maxItemsInLine = 3
    lazy private var dataManager = DataManager.shared
    
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
        
        gallery.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "reuseID")
        
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
        dataManager.asyncGetUser(by: name) { user in
            
            navigationItem.title = user.name
            let postCount = user.posts?.count ?? 0
            self.numberOfPosts.text = String(postCount)
            let followers = user.followers ?? 0
            self.numberOfFollowers.text = String(followers)
            let following = user.following ?? 0
            self.numberOfFollowing.text = String(following)

            guard let avatarURL = user.avatar, let avatarImage = UIImage(named: avatarURL) else { return }
            self.avatar.image = avatarImage
            self.avatar.contentMode = .scaleAspectFill
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension ProfileViewControllerrViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataManager.postCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseID", for: indexPath)
        
        let indicator = UIActivityIndicatorView(style: .medium)
        cell.contentView.addSubview(indicator)
        indicator.center = cell.contentView.center
        indicator.startAnimating()
        dataManager.asyncGetPost(for: indexPath.row) { (post) in
            guard let image = UIImage(named: post.photo) else { return }
            
            // FIXME: - Fix filling cell with image with proportional scaling
            let cellSize = cell.bounds.size
            DispatchQueue.global(qos: .utility).async {
                let resizedImage = resized(image, to: cellSize)
                DispatchQueue.main.async {
                    indicator.stopAnimating()
                    indicator.removeFromSuperview()
                    let imageView = UIImageView(image: resizedImage)
                    imageView.contentMode = .scaleToFill

                    cell.contentView.addSubview(imageView)
                    cell.contentMode = .scaleAspectFit
                }
            }
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let postsListVC = storyboard?.instantiateViewController(identifier: "postListView") else { return }
        guard let vc = postsListVC as? PostsListViewController else { return }
        vc.currentPost = dataManager.syncGetPost(for: indexPath.row)
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

