//
//  ProfileViewControllerrViewController.swift
//  InstaClient
//
//  Created by Maksim Torburg on 14.05.2020.
//  Copyright © 2020 Maksim Torburg. All rights reserved.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    var user: User? = nil
    private var router: ProfileRouter?
//    var userFetchReslutController: NSFetchedResultsController<User>!
//    var postFetchReslutController: NSFetchedResultsController<Post>!

    var avatar: UIImageView!
    var numberOfPosts: UILabel!
    var numberOfFollowers: UILabel!
    var numberOfFollowing: UILabel!
    var userInformation: UITextField!
    var gallery: UICollectionView!
    var editButton: UIButton!
    var editAvatarButton: UIButton!
    
    var headerStackView: UIStackView!
    var headerGalleryStackView: UIStackView!
    
    private let minimumSpacing: CGFloat = 3.0
    private let maxItemsInLine = 3
    lazy private var dataManager = DataManager.shared
    
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        let router = ProfileRouter(rootViewController: self)
        self.router = router
        setupView()
        getData()
    }

    func setupView() {
        view.backgroundColor = .white
        
        avatar = UIImageView()
        view.addSubview(avatar)
        
        userInformation = UITextField()
        view.addSubview(userInformation)

        configureNavigationBar()
        configureHeaderStackView()
        configureEditButton()
        configureEditAvatarButton()
        configureHeaderGallery()
        configureGallery()
        setConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // FIXME: - Problem with image resizing
        // By default, the corner radius does not apply to the image in the layer’s contents property;
        // it applies only to the background color and border of the layer.
        // Only in this method avatar has bounds to calculate corner radius.
        avatar.layer.masksToBounds = true
        avatar.layer.cornerRadius = avatar.bounds.width / 2
    }
    
    fileprivate func configureNavigationBar() {
        dump(navigationController)
        navigationController?.navigationBar.backgroundColor = view.backgroundColor
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
        navigationController?.navigationBar.backIndicatorImage?.withTintColor(.black)
        navigationController?.navigationBar.backIndicatorTransitionMaskImage?.withTintColor(.black)

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
    }
    
    fileprivate func configureHeaderStackView() {
        headerStackView = {
            let view = UIStackView()
            view.axis = .horizontal
            view.distribution = .fillEqually
            return view
        }()
        view.addSubview(headerStackView)
        
        let posts: UIStackView = {
            let view = UIStackView()
            numberOfPosts = UILabel()
            numberOfPosts.text = "30"
            numberOfPosts.font = UIFont(name: "Roboto-Medium", size: 17)
            view.addArrangedSubview(numberOfPosts)
            
            let posts = UILabel()
            posts.text = "Posts"
            posts.font = .systemFont(ofSize: 12)
            view.addArrangedSubview(posts)
            return view
        }()
        headerStackView.addArrangedSubview(posts)
        
        let followers: UIStackView = {
            let view = UIStackView()
            numberOfFollowers = UILabel()
            numberOfFollowers.text = "0"
            numberOfFollowers.font = UIFont(name: "Roboto-Medium", size: 17)
            view.addArrangedSubview(numberOfFollowers)
            
            let followers = UILabel()
            followers.text = "Followers"
            followers.font = .systemFont(ofSize: 12)
            view.addArrangedSubview(followers)
            return view
        }()
        headerStackView.addArrangedSubview(followers)
        
        let following: UIStackView = {
            let view = UIStackView()
            numberOfFollowing = UILabel()
            numberOfFollowing.font = UIFont(name: "Roboto-Medium", size: 17)
            numberOfFollowing.text = "150"
            view.addArrangedSubview(numberOfFollowing)
            
            let following = UILabel()
            following.text = "Following"
            following.font = .systemFont(ofSize: 12)
            view.addArrangedSubview(following)
            return view
        }()
        
        headerStackView.addArrangedSubview(following)
        
        for stackView in headerStackView.arrangedSubviews {
            guard let view = stackView as? UIStackView else { return }
            view.axis = .vertical
            view.distribution = .fill
            view.alignment = .center
            view.spacing = 0
            view.contentMode = .scaleToFill
        }
    }
    
    fileprivate func configureEditButton() {
        let title: NSAttributedString = {
            let text = "Edit button"
            let attributes: [NSAttributedString.Key : Any ] = [
                .font : UIFont.systemFont(ofSize: 12),
                .foregroundColor : UIColor.black
            ]
            return NSAttributedString(string: text, attributes: attributes)
        }()
        editButton = {
            let button = UIButton()
            button.setAttributedTitle(title, for: .normal)
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor(red: 0.859, green: 0.859, blue: 0.859, alpha: 1).cgColor
            return button
        }()
        view.addSubview(editButton)
    }
    
    fileprivate func configureEditAvatarButton() {
        editAvatarButton = {
            let button = UIButton()
            let plusImage = UIImage(named: "plus")
            button.setImage(plusImage, for: .normal)
            return button
        }()
        view.addSubview(editAvatarButton)
    }
    
    fileprivate func configureHeaderGallery() {
        headerGalleryStackView = {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.distribution = .fillEqually
            stack.alignment = .fill
            stack.spacing = 0
            stack.contentMode = .scaleToFill
            return stack
        }()
        let grid = UIImageView(image: UIImage(named: "grid_icon"))
        grid.contentMode = .center
        let taged = UIImageView(image: UIImage(named: "taged_icon"))
        taged.contentMode = .center
        headerGalleryStackView.addArrangedSubview(grid)
        headerGalleryStackView.addArrangedSubview(taged)
        view.addSubview(headerGalleryStackView)
    }
    
    fileprivate func configureGallery() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        gallery = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        gallery.backgroundColor = .white
        view.addSubview(gallery)
        
        gallery.delegate = self
        gallery.dataSource = self
        gallery.register(GalleryViewCell.self, forCellWithReuseIdentifier: GalleryViewCell.reuseID)
    }
    
    fileprivate func setConstraints() {
        avatar.translatesAutoresizingMaskIntoConstraints = false
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        userInformation.translatesAutoresizingMaskIntoConstraints = false
        editButton.translatesAutoresizingMaskIntoConstraints = false
        headerGalleryStackView.translatesAutoresizingMaskIntoConstraints = false
        gallery.translatesAutoresizingMaskIntoConstraints = false
        editAvatarButton.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            avatar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            avatar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            avatar.heightAnchor.constraint(equalToConstant: 77),
            avatar.widthAnchor.constraint(equalTo: avatar.heightAnchor),

            headerStackView.topAnchor.constraint(equalTo: avatar.topAnchor),
            headerStackView.bottomAnchor.constraint(equalTo: avatar.bottomAnchor),
            headerStackView.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 15),
            headerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),

            userInformation.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 20),
            userInformation.leadingAnchor.constraint(equalTo: avatar.leadingAnchor),
            userInformation.trailingAnchor.constraint(equalTo: headerStackView.trailingAnchor),
            userInformation.heightAnchor.constraint(equalToConstant: 100),

            editButton.topAnchor.constraint(equalTo: userInformation.bottomAnchor),
            editButton.leadingAnchor.constraint(equalTo: userInformation.leadingAnchor),
            editButton.trailingAnchor.constraint(equalTo: userInformation.trailingAnchor),
            editButton.heightAnchor.constraint(equalToConstant: 30),

            headerGalleryStackView.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 20),
            headerGalleryStackView.leadingAnchor.constraint(equalTo: editButton.leadingAnchor),
            headerGalleryStackView.trailingAnchor.constraint(equalTo: editButton.trailingAnchor),
            headerGalleryStackView.heightAnchor.constraint(equalToConstant: 50),

            gallery.topAnchor.constraint(equalTo: headerGalleryStackView.bottomAnchor),
            gallery.leadingAnchor.constraint(equalTo: headerGalleryStackView.leadingAnchor),
            gallery.trailingAnchor.constraint(equalTo: headerGalleryStackView.trailingAnchor),
            gallery.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 18),

            editAvatarButton.trailingAnchor.constraint(equalTo: avatar.trailingAnchor),
            editAvatarButton.bottomAnchor.constraint(equalTo: avatar.bottomAnchor),
            editAvatarButton.heightAnchor.constraint(equalToConstant: 20),
            editAvatarButton.widthAnchor.constraint(equalToConstant: 20),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    fileprivate func getData() {
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // FIXME: - When cell is only one it's located in the center of line
        super.viewWillAppear(animated)
        getData()
        gallery.reloadData()
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate {
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
        guard let router = self.router else { return }
        guard let currentUser = user else { return }
        guard let post = dataManager.syncGetPost(of: currentUser, for: indexPath) else { return }
        router.goToPostsList(to: post)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
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

