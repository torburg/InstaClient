//
//  ProfileViewControllerrViewController.swift
//  InstaClient
//
//  Created by Maksim Torburg on 14.05.2020.
//  Copyright © 2020 Maksim Torburg. All rights reserved.
//

import UIKit

class ProfileViewControllerrViewController: UIViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var numberOfPosts: UILabel!
    @IBOutlet weak var numberOfFollowers: UILabel!
    @IBOutlet weak var numberOfFollowing: UILabel!
    
    @IBOutlet weak var gallery: UICollectionView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    
    private let minimumSpacing: CGFloat = 3.0
    private let imagesCount = 6
    private let maxItemsInLine = 3
    private let dataManager = DataManager()
    
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
    }
    
    func getData() {
        guard let name = UserDefaults.standard.value(forKey: "UserName") as? String else { return }
        dataManager.fetch(by: name) { user in
            
            self.name.text = user.name
            let postCount = user.posts?.count ?? 0
            self.numberOfPosts.text = String(postCount)
            let followers = user.followers ?? 0
            self.numberOfFollowers.text = String(followers)
            let following = user.following ?? 0
            self.numberOfFollowing.text = String(following)

            guard let avatarURL = user.avatar, let avatarImage = UIImage(named: avatarURL) else { return }
            self.avatar.image = resized(avatarImage, to: self.avatar.frame.size)
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
        
        dataManager.getPost(for: indexPath.row) { (post) in
            guard let image = UIImage(named: post.photo) else { return }
            let resizedImage = resized(image, to: cell.bounds.size)
            let imageView = UIImageView(image: resizedImage)
            imageView.contentMode = .scaleAspectFit

            cell.contentView.addSubview(imageView)
            cell.contentMode = .scaleAspectFit
        }

        return cell
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

