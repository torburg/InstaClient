//
//  ProfilePresenter.swift
//  InstaClient
//
//  Created by Maksim Torburg on 27.08.2020.
//  Copyright © 2020 Maksim Torburg. All rights reserved.
//

import Foundation
import UIKit

typealias ProfileWithCollectionViewPresenter = ProfilePresenterProtocol & UICollectionViewDataSource

protocol ProfileViewProtocol: class {
    func setData(with: User)
}

protocol ProfilePresenterProtocol: class {
    init(view: ProfileViewProtocol, dataManager: DataManagerProtocol, router: ProfileRouter)
    func getData()
    func goToPostsList(to indexPath: IndexPath)
}

class ProfilePresenter: NSObject, ProfileWithCollectionViewPresenter {
    let view: ProfileViewProtocol
    let dataManager: DataManagerProtocol
    
    // FIXME: - Change to Protocol
    let router: ProfileRouter
    
    var user: User? = nil
    
    required init(view: ProfileViewProtocol, dataManager: DataManagerProtocol, router: ProfileRouter) {
        self.view = view
        self.dataManager = dataManager
        self.router = router
    }
    
    func getData() {
        let name = "sofya"
        guard let user = dataManager.syncGetUser(by: name) else { return }
        self.user = user
        view.setData(with: user)
    }
    
    func goToPostsList(to indexPath: IndexPath) {
        guard let currentUser = user else { return }
        guard let post = dataManager.syncGetPost(of: currentUser, for: indexPath) else { return }
        router.goToPostsList(to: post)
    }
}

// MARK: - UICollectionViewDataSource

extension ProfilePresenter {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let currentUser = user else { return 0 }
        return dataManager.postCount(for: currentUser) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dequedCell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryViewCell.reuseID, for: indexPath)
        guard let cell = dequedCell as? GalleryViewCell else { return dequedCell }
        cell.user = user
        cell.dataManager = dataManager
        cell.onBind(for: indexPath)
        return cell
    }
}
