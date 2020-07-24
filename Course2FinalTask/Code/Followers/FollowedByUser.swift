//
//  Followers.swift
//  Course2FinalTask
//
//  Created by Калинин Артем Валериевич on 23.07.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import UIKit
import DataProvider



class FollowedByUser: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let followedByUser = user.usersFollowedByUser(with: currentUser.id)
    var unwrappedFollowedByUser = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension FollowedByUser: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followedByUser?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "followedCell", for: indexPath) as! FollowedByUserTableViewCell
        guard let friend = followedByUser?[indexPath.row] else {return fatalError("nothing here") as! UITableViewCell}
        cell.userName.text = friend.fullName
        cell.userPhoto.image = friend.avatar
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
