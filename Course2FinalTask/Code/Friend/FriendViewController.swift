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

    override func viewDidLoad() {
        super.viewDidLoad()
        setUser()
    }
    
    func setUser() {
        guard let friend = currentFriend else {return}
        friendAvatar.image = friend.avatar
        friendAvatar.layer.cornerRadius = friendAvatar.frame.size.width / 2
        friendUserName.text = friend.fullName
        friendFollowersCount.text = String(friend.followedByCount)
        friendFollowingCount.text = String(friend.followsCount)
    }
}
