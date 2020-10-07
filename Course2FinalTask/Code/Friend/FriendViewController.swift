//
//  FriendViewController.swift
//  Course2FinalTask
//
//  Created by Калинин Артем Валериевич on 28.07.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

//Подписчики followed
var currentUserFollowers = [User]()
//Подписчики following
var currentUserFollowing = [User]()

//MARK: - Friend View (экран ДРУГА)

class FriendViewController: UIViewController {
    
    @IBOutlet weak var friendAvatar: UIImageView!
    @IBOutlet weak var friendUserName: UILabel!
    @IBOutlet weak var friendFollowersCount: UILabel!
    @IBOutlet var friendFollowingCount: UILabel!
    @IBOutlet weak var friendCollectionView: UICollectionView!
    @IBOutlet weak var followButtonLable: UIButton!
    @IBOutlet weak var buttonActiveIndicator: UIActivityIndicatorView!
    
    let post = DataProviders.shared.postsDataProvider
    var friendIndicator = UIActivityIndicatorView()
    var invisibleView = UIView()
    var lebleOfFollowButton = ""
    
    var currentUser: User?
    var currentFriend: User?
    var gettingFriend: User?
    var unwrappedArrayOfFriendPost = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUser()
        setLayout()
        getFriend()
        indicator()
        indicatorOfButton()
        friendCollectionView.reloadData()
        friendCollectionView.delegate = self
        friendCollectionView.dataSource = self
        friendCollectionView.register(FriendCollectionViewCell.nib(), forCellWithReuseIdentifier: FriendCollectionViewCell.identifire)
    }
    
    //MARK: - функции viewDidLoad
    // Тап на подписчиков
    @objc func tapFollowers(sender: UITapGestureRecognizer) {
        let vc = FollowedByUser()
        show(vc, sender: self)
    }
    
    // Устанавливаем Юзера на View
    func setUser() {
        guard let friend = currentFriend else {return}
        user.user(with: friend.id, queue: DispatchQueue.global()) { (user) in
            guard user != nil else {return self.alertMessage()}
            self.getFollower()
            self.getFriend()
            self.getCurrentUser()
            DispatchQueue.main.async {
                self.gettingFriend = user
                guard let getFriend = self.gettingFriend else {return}
                self.friendAvatar.image = getFriend.avatar
                self.friendAvatar.layer.cornerRadius = self.friendAvatar.frame.size.width / 2
                self.friendUserName.text = getFriend.fullName
                self.friendFollowersCount.text = String(getFriend.followedByCount)
                self.friendFollowingCount.text = String(getFriend.followsCount)
                self.title = getFriend.username
                self.setFollowButton()
                self.getCurrentUser()
            }
        }
    }
    
    // Индикатор
    func indicator() {
        invisibleView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        invisibleView.backgroundColor = .white
        friendIndicator.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        friendIndicator.center = self.invisibleView.center
        friendIndicator.startAnimating()
        invisibleView.addSubview(friendIndicator)
        view.addSubview(invisibleView)
    }
    
    //Устанавливаем КНОПКУ Follow/UnFollow
    func setFollowButton() {
        followButtonLable.backgroundColor = #colorLiteral(red: 0, green: 0.5882352941, blue: 1, alpha: 1)
        followButtonLable.layer.cornerRadius = 6
        followButtonLable.setTitle(lebleOfFollowButton, for: .normal)
        if let friend = currentFriend {
            if friend.currentUserFollowsThisUser == true {
                followButtonLable.setTitle("UnFollow", for: .normal)
            } else {
                followButtonLable.setTitle("Follow", for: .normal)
            }
        }
    }
    
    //Функция для проверки текущего пользователя Если он убираем кнопку follow
    func getCurrentUser() {
        user.currentUser(queue: DispatchQueue.global()) { (user) in
            guard user != nil else {return self.alertMessage()}
            self.currentUser = user
            DispatchQueue.main.async {
                if self.gettingFriend?.id == self.currentUser?.id {
                    self.followButtonLable.isHidden = true
                    self.invisibleView.isHidden = true
                } else {
                    self.invisibleView.isHidden = true
                }
            }
        }
    }
    
    //Получаем подписчиков ДРУГА. HIdden
    func getFollower() {
        guard let friend = currentFriend else {return}
        user.usersFollowedByUser(with: friend.id, queue: DispatchQueue.global()) { (followers) in
            guard followers != nil else {return self.alertMessage()}
            DispatchQueue.main.async {
                currentUserFollowers = followers ?? []
            }
        }
        user.usersFollowingUser(with: friend.id, queue: DispatchQueue.global()) { (following) in
            guard following != nil else {return self.alertMessage()}
            DispatchQueue.main.async {
                currentUserFollowing = following ?? []
            }
        }
    }
    
    //функция где мы достаем из DataProvider посты для ДРУГА. HIdden
    func getFriend() {
        if let currentFriend = currentFriend {
            //Если массив пуст, заполняем его
            if unwrappedArrayOfFriendPost.isEmpty {
                post.findPosts(by: currentFriend.id, queue: DispatchQueue.global()) { (arrayFriendPost) in
                    guard arrayFriendPost != nil else {return self.alertMessage()}
                    DispatchQueue.main.async {
                        self.unwrappedArrayOfFriendPost = arrayFriendPost ?? []
                        self.friendCollectionView.reloadData()
                    }
                }
            } else {
                //Если не пуст, удаляем из него все посты и заливаем новые во избежании ошибки "Index out of range"
                unwrappedArrayOfFriendPost.removeAll()
                post.findPosts(by: currentFriend.id, queue: DispatchQueue.global()) { (arrayFriendPost) in
                    guard arrayFriendPost != nil else {return self.alertMessage()}
                    DispatchQueue.main.async {
                        self.unwrappedArrayOfFriendPost = arrayFriendPost ?? []
                        self.friendCollectionView.reloadData()
                    }
                }
            }
        }
    }
    
    //MARK: - Констрейнты
    func setLayout() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        friendCollectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    //MARK: - Make Scroll (Делаем скрол)
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var rect = self.view.frame
        rect.origin.y =  -scrollView.contentOffset.y
        self.view.frame = rect
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        friendCollectionView.reloadData()
    }
    
    
    //MARK: - FOLLOWERS
    // Передаем на экран подписчики друга массив с Followers или Following
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "friendFollowing" {
            let destination = segue.destination as? FollowedByUser
            destination?.mainTitle = "Following"
            destination?.friends = currentUserFollowers
        } else if segue.identifier == "friendFollowers" {
            let destination = segue.destination as? FollowedByUser
            destination?.mainTitle = "Followers"
            destination?.friends = currentUserFollowing
        }
    }
    
    //MARK: - КНОПКА FOLLOW
    @IBAction func followButton(_ sender: Any) {
        
        self.buttonActiveIndicator.isHidden = false
        self.buttonActiveIndicator.startAnimating()
        self.followButtonLable.setTitle("", for: .normal)
        guard let current = currentFriend else {return}
        if followButtonLable.titleLabel?.text == "Follow" {
            user.follow(current.id, queue: DispatchQueue.global()) { (_) in
                DispatchQueue.main.async {
                    self.lebleOfFollowButton = "Unfollow"
                    self.followButtonLable.setTitle(self.lebleOfFollowButton, for: .normal)
                    self.buttonActiveIndicator.isHidden = true
                    self.buttonActiveIndicator.stopAnimating()
                    self.updateUI()
                }
            }
        } else {
            user.unfollow(current.id, queue: DispatchQueue.global()) { (_) in
                DispatchQueue.main.async {
                    self.lebleOfFollowButton = "Follow"
                    self.followButtonLable.setTitle(self.lebleOfFollowButton, for: .normal)
                    self.buttonActiveIndicator.isHidden = true
                    self.buttonActiveIndicator.stopAnimating()
                    self.updateUI()
                }
            }
        }
    }
    
    //обновляем UI интерфйес после того как текущий пользователь подписался/отписался
    func updateUI() {
        guard let friend = currentFriend else {return self.alertMessage()}
        user.user(with: friend.id, queue: DispatchQueue.global()) { (user) in
            guard user != nil else {return}
            DispatchQueue.main.async {
                self.gettingFriend = user
                guard let getFriend = self.gettingFriend else {return}
                self.friendFollowersCount.text = String(getFriend.followedByCount)
                self.friendFollowingCount.text = String(getFriend.followsCount)
                self.title = getFriend.username
                self.getFollower()
                self.getFriend()
            }
        }
    }
    
    
    //Индикатор для кнопки Follow
    func indicatorOfButton() {
        buttonActiveIndicator.isHidden = true
        buttonActiveIndicator.color = .white
    }
    
    //Функция сообщающая об ошибке
    func alertMessage() {
        let alertController = UIAlertController(title: "Unknown error!", message: "Please, try again later.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
}

//MARK: - Расширения

extension FriendViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return unwrappedArrayOfFriendPost.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendCell", for: indexPath) as? FriendCollectionViewCell else {return UICollectionViewCell()}
        let aaa = self.unwrappedArrayOfFriendPost[indexPath.row]
        cell.friendImageView.image = aaa.image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width/3.0, height: UIScreen.main.bounds.size.width/3.0)
    }
}

