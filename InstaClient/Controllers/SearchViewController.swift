//
//  SearchViewController.swift
//  InstaClient
//
//  Created by Maksim Torburg on 18.09.2020.
//  Copyright © 2020 Maksim Torburg. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController: UIViewController, SearchViewProtocol {

    var presenter: SearchWithCollectionViewPresenter!
    var gallery: UICollectionView!
    
    private let minimumSpacing: CGFloat = 3.0
    private let maxItemsInLine = 3
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.getData()
    }
    
    func setData() {
        configureNavigationBar()
        configureGallery()
        setConstraints()
    }
    
    fileprivate func configureNavigationBar() {
        navigationController?.navigationBar.backgroundColor = view.backgroundColor
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
        navigationController?.navigationBar.backIndicatorImage?.withTintColor(.black)
        navigationController?.navigationBar.backIndicatorTransitionMaskImage?.withTintColor(.black)

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
    }
    
    func configureGallery() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        gallery = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        gallery.backgroundColor = .white
        view.addSubview(gallery)
        
        gallery.delegate = self
        gallery.dataSource = presenter
        gallery.register(GalleryViewCell.self, forCellWithReuseIdentifier: GalleryViewCell.reuseID)
    }
    
    fileprivate func setConstraints() {
        gallery.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            gallery.topAnchor.constraint(equalTo: view.topAnchor),
            gallery.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gallery.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gallery.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SearchViewController: UICollectionViewDelegateFlowLayout {
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
