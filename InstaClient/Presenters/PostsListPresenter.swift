//
//  PostsListPresenter.swift
//  InstaClient
//
//  Created by Maksim Torburg on 27.08.2020.
//  Copyright © 2020 Maksim Torburg. All rights reserved.
//

import UIKit

typealias PostListWithTableViewAndSearchBarPresenter = PostsListPresenterProtocol & UITableViewDataSource & UISearchBarDelegate

protocol PostsListViewProtocol: class {
    func scrollToPost(at indexpath: IndexPath, at position: UITableView.ScrollPosition, isAnimated: Bool)
    func deletePost(at index: Int)
    func reloadPostslist()
}

protocol PostsListPresenterProtocol: class {
    var currentUserName: String { get set }
    init(view: PostsListViewProtocol, dataManager: DataManager, router: ProfileRouter)
    func setData()
    func scrollToPost()
}

class PostsListPresenter: NSObject, PostsListPresenterProtocol {
    
    let view: PostsListViewProtocol
    let dataManager: DataManager
    let router: ProfileRouter
    
    var currentUser: User? = nil
    var currentPost: Post? = nil
    
    var isFiltering: Bool {
        if let postsListView = view as? PostsListViewController {
            return postsListView.isFiltering
        } else { return false }
    }
    
    lazy var filteredPosts = [Post]()
    
    lazy var currentUserName: String = {
        return self.currentUser?.name.uppercased() ?? ""
    }()
    
    required init(view: PostsListViewProtocol, dataManager: DataManager, router: ProfileRouter) {
        self.view = view
        self.dataManager = dataManager
        self.router = router
    }
    
    func setData() {
        currentUser = dataManager.syncGetUser(by: "sofya")
    }
    
    func scrollToPost() {
        guard let post = currentPost else { return }
        guard let user = currentUser else { return }
        guard let index = dataManager.getIndex(of: post, of: user) else { return }
        // MARK: - It doesn't work w/o asyncAfter. Miliseconds aren't nessesary.
        // FIXME: - Should open current post w/o downloading every post in table
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(50)) {
            self.view.scrollToPost(at: IndexPath(row: index, section: 0), at: .top, isAnimated: true)
        }
    }
}

extension PostsListPresenter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let user = currentUser else { return 0 }
        if isFiltering {
            return filteredPosts.count
        } else {
            return dataManager.postCount(for: user) ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequedCell = tableView.dequeueReusableCell(withIdentifier: PostViewCell.reuseID, for: indexPath)
        guard let cell = dequedCell as? PostViewCell else { return dequedCell }
        cell.delegate = view
        cell.user = currentUser
        if isFiltering {
            let postViewModel = PostViewModel()
            postViewModel.post = filteredPosts[indexPath.row]
            cell.fillCell(with: postViewModel)
        } else {
            cell.onBind(for: indexPath)
        }
        return cell
    }
}

extension PostsListPresenter: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let user = currentUser else { return }
        // FIXME: - Put it in ViewModel and fix filtering
        dataManager.filterPosts(of: user, contains: searchText) { [weak self] (posts) in
            guard let self = self else { return }
//            self.filteredPosts = posts
            self.view.reloadPostslist()
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
