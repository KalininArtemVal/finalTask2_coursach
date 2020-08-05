//
//  ProfileViewController.swift
//  Course2FinalTask
//
//  Created by Калинин Артем Валериевич on 20.07.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

//MARK: - вызываем user
let user = DataProviders.shared.usersDataProvider
let currentUser = user.currentUser()

//MARK: - Profile of Сurrent User (Страница текущего пользователя)
class ProfileViewController: UIViewController {
    
    @IBOutlet weak var imageLable: UIImageView!
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var countOfFollowers: UILabel!
    @IBOutlet weak var countOfFollowing: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var animatoin: UIViewPropertyAnimator!
    var arrayOfCurrentPost = post.findPosts(by: currentUser.id)//[Post]()
    var arrayOfCurrentPostUnwrapped = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        newMan()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(NewProfileCollectionViewCell.nib(), forCellWithReuseIdentifier: NewProfileCollectionViewCell.identifire)
        collectionView.reloadData()
        self.collectionView.alwaysBounceVertical = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var rect = self.view.frame
        rect.origin.y =  -scrollView.contentOffset.y
        self.view.frame = rect
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "followers" {
            let destination = segue.destination as? FollowedByUser
            destination?.mainTitle = "Followers"
            destination?.friends = followingUser
        } else if segue.identifier == "following" {
            let destination = segue.destination as? FollowedByUser
            destination?.mainTitle = "Following"
            destination?.friends = followedByUser
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    func setLayout() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    private func newMan() {
        imageLable.image = currentUser.avatar
        imageLable.layer.cornerRadius = imageLable.frame.size.width / 2
        nameLable.text = currentUser.fullName
        let followers = currentUser.followedByCount
        let followedBy = currentUser.followsCount
        countOfFollowers.text = String(followers)
        countOfFollowing.text = String(followedBy)
//        title = currentUser.username
    }
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let arrayOfCurrentPost = arrayOfCurrentPost {
            for post in arrayOfCurrentPost {
                arrayOfCurrentPostUnwrapped.append(post)
            }
        }
        return arrayOfCurrentPostUnwrapped.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileCell", for: indexPath) as? NewProfileCollectionViewCell else {fatalError("hogeCell not registered.")}
        if let arrayOfCurrentPost = arrayOfCurrentPost {
            for post in arrayOfCurrentPost {
                arrayOfCurrentPostUnwrapped.append(post)
                let post = arrayOfCurrentPostUnwrapped[indexPath.row]
                cell.configue(with: post.image)
                return cell
            }
            let post = arrayOfCurrentPostUnwrapped[indexPath.row]
            cell.configue(with: post.image)
            return cell
        }
        return cell
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width/3.0, height: UIScreen.main.bounds.size.width/3.0)
    }
    
}
