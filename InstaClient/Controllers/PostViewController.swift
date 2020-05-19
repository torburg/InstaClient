//
//  PostViewController.swift
//  InstaClient
//
//  Created by Maksim Torburg on 16.05.2020.
//  Copyright © 2020 Maksim Torburg. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

    var post: Post?
    
    @IBOutlet weak var postImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillData()
    }
    
    func fillData() {
        guard let post = post else { return }
        let imageURL = post.photo
        postImage.image = UIImage(named: imageURL)
    }
}
