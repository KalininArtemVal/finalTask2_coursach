//
//  FriendViewController.swift
//  Course2FinalTask
//
//  Created by Калинин Артем Валериевич on 28.07.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

class FriendViewController: UIViewController {
    
    @IBOutlet weak var friendAvatar: UIImageView!
    @IBOutlet weak var friendUserName: UILabel!
    @IBOutlet weak var friendFollowersCount: UILabel!
    @IBOutlet var friendFollowingCount: UILabel!
    @IBOutlet weak var friendCollectionView: UICollectionView!
    
    var currentFriend: User?
    var unwrappedArrayOfFriendPost = [Post]()
    
    static let identifire = "FriendViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendCollectionView.delegate = self
        friendCollectionView.dataSource = self
        setUser()
        friendCollectionView.register(FriendCollectionViewCell.nib(), forCellWithReuseIdentifier: FriendCollectionViewCell.identifire)
        setLayout()
    }
    
    @objc func tapFollowers(sender: UITapGestureRecognizer) {
        let vc = FollowedByUser()
        show(vc, sender: self)
    }
    
    func setUser() {
        guard let friend = currentFriend else {return}
        friendAvatar.image = friend.avatar
        friendAvatar.layer.cornerRadius = friendAvatar.frame.size.width / 2
        friendUserName.text = friend.fullName
        friendFollowersCount.text = String(friend.followedByCount)
        friendFollowingCount.text = String(friend.followsCount)
        title = friend.username
    }
    
    func setLayout() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        friendCollectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "friendFollowing" {
            let destination = segue.destination as? FollowedByUser
            let currentUserFollowers = user.usersFollowedByUser(with: currentFriend?.id ?? currentUser.id)
            destination?.friends = currentUserFollowers
        } else if segue.identifier == "friendFollowers" {
            let destination = segue.destination as? FollowedByUser
            let currentUserFollowing = user.usersFollowingUser(with: currentFriend?.id ?? currentUser.id)
            destination?.friends = currentUserFollowing
        }
    }
}

extension FriendViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let currentFriend = currentFriend {
            if let arrayOfCurrentFriendPost = post.findPosts(by: currentFriend.id) {
                for i in arrayOfCurrentFriendPost {
                        unwrappedArrayOfFriendPost.append(i)
                }
            }
        }
        return unwrappedArrayOfFriendPost.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendCell", for: indexPath) as? FriendCollectionViewCell else {return fatalError() as! UICollectionViewCell}
        
        if let currentFriend = currentFriend {
            let arrayOfCurrentFriendPost = post.findPosts(by: currentFriend.id)
            if let currentFriend = arrayOfCurrentFriendPost?[indexPath.row] {
                cell.friendImageView.image = currentFriend.image
                return cell
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width/3.0, height: UIScreen.main.bounds.size.width/3.0)
    }
}

