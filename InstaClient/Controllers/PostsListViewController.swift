//
//  PostsListViewController.swift
//  InstaClient
//
//  Created by Maksim Torburg on 19.05.2020.
//  Copyright © 2020 Maksim Torburg. All rights reserved.
//

import UIKit

class PostsListViewController: UIViewController {

    @IBOutlet weak var postsList: UITableView!
    var currentUser: User? = nil
    var currentPost: Post? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataManager.shared.asyncGetUser(by: "sofya") { user in
            self.currentUser = user
        }
        
        setNavigationView()
        
        guard let post = currentPost else { return }
        guard let user = currentUser else { return }
        guard let index = DataManager.shared.getIndex(of: post, of: user) else { return }
        // MARK: - It doesn't work w/o asyncAfter. Miliseconds aren't nessesary.
        // FIXME: - Should open current post w/o downloading every post in table
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(50)) {
            self.postsList.scrollToRow(at: IndexPath(item: index, section: 0), at: .top, animated: true)
        }
    }
    
    func setNavigationView() {
        let name = UILabel()
        name.text = currentUser?.name.uppercased()
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
}

extension PostsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let user = currentUser else { return 0 }
        return DataManager.shared.postCount(for: user)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequedCell = postsList.dequeueReusableCell(withIdentifier: PostViewCell.reuseID, for: indexPath)
        guard let cell = dequedCell as? PostViewCell else { return dequedCell }
        cell.actionDelegate = self
        cell.user = currentUser
        cell.onBind(for: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 640
    }
}

extension PostsListViewController {
    func deletePost(at index: Int, by action: UIAlertAction) {
        postsList.deleteRows(at: [IndexPath(item: index, section: 0)], with: .left)
        postsList.reloadData()
    }
}
