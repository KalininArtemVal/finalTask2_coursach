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
        setLayout()
        feedCollectionView.dataSource = self
        feedCollectionView.delegate = self
        feedCollectionView.register(FeedCollectionViewCell.nib(), forCellWithReuseIdentifier: FeedCollectionViewCell.identifire)
        feedCollectionView.reloadData()
    }
    
    func setLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 415, height: 650)
        feedCollectionView.collectionViewLayout = layout
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
            cell.imageHeartOfLike.image = #imageLiteral(resourceName: "like")
            cell.imageHeartOfLike.tintColor = .systemBlue
        } else {
            cell.imageHeartOfLike.image = #imageLiteral(resourceName: "like")
            cell.imageHeartOfLike.tintColor = .lightGray
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

extension FeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 415, height: 600)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
