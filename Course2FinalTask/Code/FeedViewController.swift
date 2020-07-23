//
//  FeedViewController.swift
//  Course2FinalTask
//
//  Created by Калинин Артем Валериевич on 19.07.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

let arrayOfPosts = post.feed()
var arrayOfPostsWithoutNil = [Post]()


class FeedViewController: UIViewController {
    
    
    @IBOutlet weak var feedCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedCollectionView.dataSource = self
        feedCollectionView.delegate = self
        feedCollectionView.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: "feedCell")
        feedCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        feedCollectionView.reloadData()
    }
}


extension FeedViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "feedCell", for: indexPath) as? FeedCollectionViewCell else {fatalError("ERRoR!")}
        
        let post = arrayOfPosts[indexPath.item]
        
        if post.currentUserLikesThisPost == true {
            cell.heartOfLike?.imageView?.image = #imageLiteral(resourceName: "like")
        } else {
            cell.heartOfLike?.imageView?.image = #imageLiteral(resourceName: "bigLike")
        }
        cell.userName?.titleLabel?.text = post.authorUsername
        cell.countOfLikes?.titleLabel?.text = String(post.likedByCount)
        cell.descriptionTextLable?.text = post.description
        cell.dateOfPublishing?.text = post.createdTime.description
        cell.userAvatar?.image = post.authorAvatar
        cell.postImage?.image = post.image
       
        return cell
    }
}
