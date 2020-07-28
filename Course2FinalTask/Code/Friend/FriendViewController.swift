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
        friendAvatar.image = currentFriend?.avatar
        friendUserName.text = currentFriend?.fullName
        friendFollowersCount.text = String(currentFriend?.followedByCount ?? 0)
        friendFollowingCount.text = String(currentFriend?.followsCount ?? 0)
    }

}
