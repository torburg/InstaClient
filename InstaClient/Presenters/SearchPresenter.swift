//
//  SearchPresenter.swift
//  InstaClient
//
//  Created by Maksim Torburg on 18.09.2020.
//  Copyright © 2020 Maksim Torburg. All rights reserved.
//

import Foundation
import UIKit

typealias SearchWithCollectionViewPresenter = SearchPresenterProtocol & UICollectionViewDataSource

protocol SearchViewProtocol {
    func setData()
}

protocol SearchPresenterProtocol: class {
    init(view: SearchViewProtocol, dataManager: DataManagerProtocol, router: SearchViewRouter)
    func getData()
}

class SearchPresenter: NSObject, SearchWithCollectionViewPresenter {
    let view: SearchViewProtocol
    let dataManager: DataManagerProtocol
    let router: SearchViewRouter
    
    func getData() {
//        guard let posts = dataManager.getAllPosts() else { return }
        view.setData()
    }
    
    required init(view: SearchViewProtocol, dataManager: DataManagerProtocol, router: SearchViewRouter) {
        self.view = view
        self.dataManager = dataManager
        self.router = router
    }
    
}

// MARK: - UICollectionViewDataSource
extension SearchPresenter {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = dataManager.getAllPosts()?.count ?? 0
        return count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dequedCell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryViewCell.reuseID, for: indexPath)
        guard let cell = dequedCell as? GalleryViewCell else { return dequedCell }
        cell.dataManager = dataManager
        cell.onBind(for: indexPath)
        return cell
    }
}

