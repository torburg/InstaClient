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
    let dataManager = DataManager()
    var user: User? = nil
    var currentPost: Post? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager.fetch(by: "sofya") { user in
            self.user = user
        }
        
        setNavigationView()
        
        guard let post = currentPost else { return }
        guard let index = dataManager.getIndex(for: post) else { return }
        // MARK: - It doesn't work w/o asyncAfter. Miliseconds aren't nessesary.
        // FIXME: - Should open current post w/o downloading every post in table
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(50)) {
            self.postsList.scrollToRow(at: IndexPath(item: index, section: 0), at: .top, animated: true)
        }
    }
    
    func setNavigationView() {
        let name = UILabel()
        name.text = user?.name.uppercased()
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
        return dataManager.postCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequedCell = postsList.dequeueReusableCell(withIdentifier: PostViewCell.reuseID, for: indexPath)
        guard let cell = dequedCell as? PostViewCell else { return dequedCell }
        guard let post = dataManager.syncGetPost(for: indexPath.row) else { return cell }
        cell.fillData(with: post)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 640
    }
}
