//
//  PostsListViewController.swift
//  InstaClient
//
//  Created by Maksim Torburg on 19.05.2020.
//  Copyright © 2020 Maksim Torburg. All rights reserved.
//

import UIKit

class PostsListViewController: UIViewController, PostsListViewProtocol {

    var presenter: PostListWithTableViewAndSearchBarPresenter!
    
    var searchBar: UISearchBar!
    var postsList: UITableView!
    
    var isFiltering: Bool {
        return (searchBar.text != nil && !searchBar.text!.isEmpty)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(resignResponders))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        setNavigationView()
        setPostsList()
        setSearchBar()
        
        presenter.setData()
        presenter.scrollToPost()
    }
    
    func scrollToPost(at indexPath: IndexPath, at position: UITableView.ScrollPosition, isAnimated: Bool) {
        postsList.scrollToRow(at: indexPath, at: position, animated: isAnimated)
    }
    
    func setNavigationView() {
        let name = UILabel()
        name.text = presenter.currentUserName
        name.textColor = .gray
        let title = UILabel()
        title.text = "Posts"
        title.font = UIFont(name: "Roboto-Medium", size: 16)
        let stackView = UIStackView(arrangedSubviews: [name, title])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.frame.size.width = max(name.frame.width, title.frame.width)
        stackView.frame.size.height = name.frame.height + title.frame.height
        
        navigationItem.titleView = stackView
    }
    
    func setPostsList() {
        postsList = UITableView()
        
        let frame = CGRect(x: 0, y: 0, width: postsList.frame.width, height: 50)
        postsList.tableHeaderView = UIView(frame: frame)
        
        postsList.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(postsList)
        let constraints = [
            postsList.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            postsList.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            postsList.topAnchor.constraint(equalTo: view.topAnchor),
            postsList.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
        
        postsList.register(UINib(nibName: String(describing: PostViewCell.self), bundle: nil), forCellReuseIdentifier: PostViewCell.reuseID)
        postsList.dataSource = presenter
        postsList.delegate = self
    }
    
    func setSearchBar() {
        searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        guard let tableHeader = postsList.tableHeaderView else { return }
        tableHeader.addSubview(searchBar)

        let constraints = [
            searchBar.leadingAnchor.constraint(equalTo: tableHeader.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: tableHeader.trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: tableHeader.topAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
        
        searchBar.delegate = presenter
    }
    
    @objc
    func resignResponders() {
        searchBar.resignFirstResponder()
    }
    
    func reloadPostslist() {
        postsList.reloadData()
    }
    
}

extension PostsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 640
    }
}

extension PostsListViewController {
    func deletePost(at index: Int) {
        postsList.deleteRows(at: [IndexPath(item: index, section: 0)], with: .left)
        postsList.reloadData()
    }
}
