//
//  FeedViewController.swift
//  Course2FinalTask
//
//  Created by Калинин Артем Валериевич on 19.07.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

//MARK: - вызываем post
let arrayOfPosts = post.feed()
var arrayOfPostsWithoutNil = [Post]()
let post = DataProviders.shared.postsDataProvider


//MARK: - Feed (Лента)
class FeedViewController: UIViewController, UIGestureRecognizerDelegate {
    
    
    @IBOutlet weak var feedCollectionView: UICollectionView!
    
    var userOfCurrentPost: User?
    
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
        //Устанавлиывем дату
        let dateFormatter = DateFormatter()
        let createTime = post.createdTime
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        dateFormatter.doesRelativeDateFormatting = true
        let time = dateFormatter.string(from: createTime)
        
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
        cell.dateOfPublishing?.text = time
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
    
    // MARK: - didTap on Likes (Переход по тапу на кол-во Лайков)
    func didTapOnLikes(in cell: UICollectionViewCell, currentPost: Post) {
        
        guard let arrayOfLikesByUsers = post.usersLikedPost(with: currentPost.id) else {return}
        var unwrapdeArrayOfLikesByUsers = [User]()
        
        for userID in arrayOfLikesByUsers {
            if let findingUser = user.user(with: userID) {
                unwrapdeArrayOfLikesByUsers.append(findingUser)
            }
        }
        
//        if currentPost.currentUserLikesThisPost == true {
//            unwrapdeArrayOfLikesByUsers.append(currentUser)
//        }
        
        if #available(iOS 13.0, *) {
            guard let friendViewController = storyboard?.instantiateViewController(identifier: "FollowedByUser") as? FollowedByUser else { return }
            friendViewController.mainTitle = "Likes"
            friendViewController.friends = unwrapdeArrayOfLikesByUsers
            self.show(friendViewController, sender: self)
        } else {
            print("ERRoR")
        }
        
    }
    
    // MARK: - didTap on Avatar (Переход по тапу на Аватар/Имя)
    func didTap(OnAvatarIn cell: UICollectionViewCell, currentPost: Post) {
        if let follow = followingUser {
            for user in follow {
                if user.id == currentPost.author {
                    userOfCurrentPost = user
                }
            }
        }
        
        if let follow = followedByUser {
            for user in follow {
                if user.id == currentPost.author {
                    userOfCurrentPost = user
                }
            }
        }
        
        if #available(iOS 13.0, *) {
            guard let secondViewController = storyboard?.instantiateViewController(identifier: "FriendViewController") as? FriendViewController else { return }
            secondViewController.currentFriend = userOfCurrentPost
            self.show(secondViewController, sender: self)
        } else {
            print("ERRoR")
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: UIScreen.main.bounds.size.width/1.0, height: 600)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
