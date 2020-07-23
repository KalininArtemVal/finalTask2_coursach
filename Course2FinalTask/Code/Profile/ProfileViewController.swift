//
//  ProfileViewController.swift
//  Course2FinalTask
//
//  Created by Калинин Артем Валериевич on 20.07.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

let user = DataProviders.shared.usersDataProvider
let currentUser = user.currentUser()

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var imageLable: UIImageView?
    @IBOutlet weak var nameLable: UILabel?
    
    @IBOutlet weak var countOfFollowers: UILabel?
    @IBOutlet weak var countOfFollowing: UILabel?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var arrayOfCurrentPost = [Post]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newMan()
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: "ProfileCell")
        collectionView?.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView!.reloadData()
    }

    private func newMan() {
        imageLable?.image = currentUser.avatar
        imageLable?.layer.cornerRadius = (imageLable?.frame.size.width)! / 2
        nameLable?.text = currentUser.fullName
        let followers = currentUser.followedByCount
        let followedBy = currentUser.followsCount
        countOfFollowers?.text = String(followers)
        countOfFollowing?.text = String(followedBy)
    }
    
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        for currentUserPost in arrayOfPosts {
            if currentUserPost.author != currentUser.id {
                arrayOfCurrentPost.append(currentUserPost)
                print(arrayOfCurrentPost)
            }
        }
        return arrayOfCurrentPost.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as? ProfileCollectionViewCell else {fatalError("hogeCell not registered.")}
        let post = arrayOfCurrentPost[indexPath.row]
        cell.imageView?.image = post.image
        return cell
    }
}
