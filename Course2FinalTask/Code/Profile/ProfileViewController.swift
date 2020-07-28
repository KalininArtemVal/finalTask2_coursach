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
    
    @IBOutlet weak var imageLable: UIImageView!
    @IBOutlet weak var nameLable: UILabel!
    
    @IBOutlet weak var countOfFollowers: UILabel!
    @IBOutlet weak var countOfFollowing: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "followers" {
            let destination = segue.destination as? FollowedByUser
            destination?.friends = followingUser
        } else if segue.identifier == "following" {
            let destination = segue.destination as? FollowedByUser
            destination?.friends = followedByUser
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    func setLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 135, height: 130)
        layout.sectionFootersPinToVisibleBounds = true
        collectionView.collectionViewLayout = layout
        
        let numberOfItemPerRow: CGFloat = 3
        let lineSpacing: CGFloat = 1
        let interItemSpacing: CGFloat = 1
        
        let width = (collectionView.frame.width - (numberOfItemPerRow - 1) * interItemSpacing) / numberOfItemPerRow
        let height = width
        
        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets.zero
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = lineSpacing
        layout.minimumInteritemSpacing = interItemSpacing
        
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
    }
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let arrayOfCurrentPost = arrayOfCurrentPost {
            for post in arrayOfCurrentPost {
                if post != nil {
                    arrayOfCurrentPostUnwrapped.append(post)
                }
            }
        }
        return arrayOfCurrentPostUnwrapped.count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileCell", for: indexPath) as? NewProfileCollectionViewCell else {fatalError("hogeCell not registered.")}
        if let arrayOfCurrentPost = arrayOfCurrentPost {
            for post in arrayOfCurrentPost {
                if post != nil {
                    arrayOfCurrentPostUnwrapped.append(post)
                    print(arrayOfCurrentPostUnwrapped)
                    let post = arrayOfCurrentPostUnwrapped[indexPath.row]
                    cell.configue(with: post.image)
                    return cell
                }
            }
            let post = arrayOfCurrentPostUnwrapped[indexPath.row]
            cell.configue(with: post.image)
            return cell
        }
        return cell
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
}
