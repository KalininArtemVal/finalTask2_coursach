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

let post = DataProviders.shared.postsDataProvider




class FeedViewController: UIViewController, UIGestureRecognizerDelegate {
    
    
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
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
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
        cell.userName?.text = post.authorUsername
        cell.countOfLikes?.text = String(post.likedByCount)
        cell.descriptionTextLable?.text = post.description
        cell.dateOfPublishing?.text = post.createdTime.description
        cell.userAvatar?.image = post.authorAvatar
        cell.userAvatar?.layer.cornerRadius = (cell.userAvatar?.frame.size.width)! / 2
        cell.postImage?.image = post.image
        cell.currentFriend?.id = post.author
        cell.currentPost = post
        cell.delegate = self
        return cell
    }
    
}

extension FeedViewController: UICollectionViewDelegateFlowLayout, CellDelegate {
    func didTap(OnAvatarIn cell: UICollectionViewCell) {
        performSegue(withIdentifier: "showFriend", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var currentUserOfPost: User?
//        if segue.identifier == "showFriend" {
            let detailVC = segue.destination as! FriendViewController
        
//        detailVC.currentFriend = currentUser
        
//        if let indexPath = feedCollectionView.indexPathsForSelectedItems?.first {
//            let cell = feedCollectionView.cellForItem(at: indexPath) as? FeedCollectionViewCell
//            detailVC.currentFriend = cell?.currentFriend
//        }
        
//        let indexPath = feedCollectionView.indexPathsForVisibleItems
        
        
//        if let indexPath = feedCollectionView.indexPathsForVisibleItems.first {
//            let aCell = feedCollectionView.cellForItem(at: indexPath) as? FeedCollectionViewCell
//        }
            
//                detailVC.currentFriend = currentUser
            
        
            
        
//        let indexPath = feedCollectionView.indexPathsForSelectedItems
//        currentUserOfPost?.id = arrayOfPosts
//        print(arrayOfPosts[indexPath!.row].authorUsername)
//        if let currentUserPost = currentUserOfPost {
//            detailVC.currentFriend = currentUserPost
//        }
//        }
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: UIScreen.main.bounds.size.width/1.0, height: 600)
        return size
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
