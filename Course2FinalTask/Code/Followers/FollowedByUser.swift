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


//MARK: - Follow Screen (Список друзей)
class FollowedByUser: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var invisibleView = UIView()
    var friendIndicator = UIActivityIndicatorView()
    
    var friends: [User]?
    var friendsWithOutNill = [User]()
    var mainTitle = "SomeTitle"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator()
        getFriends()
        title = mainTitle
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //MARK: - Функции viewDidLoad
    func getFriends() {
        guard self.friends != nil else {return}
        self.friendsWithOutNill = self.friends ?? []
        self.tableView.reloadData()
    }
    
    func indicator() {
        invisibleView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        invisibleView.backgroundColor = .white
        view.addSubview(invisibleView)
        friendIndicator.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        friendIndicator.center = self.invisibleView.center
        friendIndicator.startAnimating()
        invisibleView.addSubview(friendIndicator)
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        invisibleView.isHidden = true
        getFriends()
        tableView.reloadData()
    }
}

//MARK: - расширения Delegate, DataSource
extension FollowedByUser: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsWithOutNill.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let friend = friendsWithOutNill[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "followedCell", for: indexPath) as! FollowedByUserTableViewCell
        cell.userName.text = friend.fullName
        cell.userPhoto.image = friend.avatar
        cell.userPhoto.layer.cornerRadius = cell.userPhoto.frame.size.width / 2
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFriend" {
            let destination = segue.destination as? FriendViewController
            if let friend = friends?[tableView.indexPathForSelectedRow!.row] {
                destination?.currentFriend = friend
            }
        }
    }
}
