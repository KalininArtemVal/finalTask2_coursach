//
//  FeedViewController.swift
//  Course2FinalTask
//
//  Created by Калинин Артем Валериевич on 19.07.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

//MARK: - Feed (Лента)
class FeedViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var activeIndicator: UIActivityIndicatorView!
    @IBOutlet weak var feedCollectionView: UICollectionView!
    
    //MARK: - Followers
    var youAreFollowed = [User]()
    
    //MARK: - вызываем post
    var feedReturn = [Post]()
    var usersLikesPostArray = [User]()
    let post = DataProviders.shared.postsDataProvider
    var lookingUser: User?
    
    var feedReturnWithOutNill = [Post]()
    let queueUtility = DispatchQueue.global(qos: .utility)
    static let identyfire = "FeedViewController"
    
    var unwrapdeArrayOfLikesByUsers = [User]()
    let dateFormatter = DateFormatter()
    var userOfCurrentPost: User?
    var following = [User]()
    var follwed = [User]()
    var curUser: User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUser()
        setLayout()
        activIndicator()
        feedCollectionView.dataSource = self
        feedCollectionView.delegate = self
        feedCollectionView.register(FeedCollectionViewCell.nib(), forCellWithReuseIdentifier: FeedCollectionViewCell.identifire)
        feedCollectionView.reloadData()
    }
    
    //MARK: - Функции viewDidLoad
    
    //Получаем посты пользователей (формируем ленту)
    func getFeed() {
        post.feed(queue: queueUtility) { [weak self] feedReturn in
            guard feedReturn != nil else {return} //self?.alertMessage()
            DispatchQueue.main.async {
                self?.activeIndicator.isHidden = true
                self?.feedReturnWithOutNill = feedReturn ?? []
                self?.feedCollectionView.reloadData()
            }
        }
    }
    
    //Индикатор активности. Работает при подгрузке данных
    func activIndicator() {
        self.activeIndicator.isHidden = false
        activeIndicator.startAnimating()
    }
    
    //Констрейнты ячейки
    func setLayout() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        feedCollectionView.collectionViewLayout = layout
    }
    
    //Получаем текущего пользователя
    func getUser() {
        user.currentUser(queue: DispatchQueue.global()) { (getuser) in
            guard getuser != nil else {return self.alertMessage()}
            self.curUser = getuser
            guard let currentUser = self.curUser else {return self.alertMessage()}
            //вытаскиваем подписчиков текущего пользователя
            user.usersFollowedByUser(with: currentUser.id, queue: DispatchQueue.global()) { (users) in
                guard users != nil else {return}
                DispatchQueue.main.async {
                    self.youAreFollowed = users ?? []
                }
            }
        }
    }
    
    //Функция сообщающая об ошибке
    func alertMessage() {
        let alertController = UIAlertController(title: "Unknown error!", message: "Please, try again later.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Обновляем ленту после публикации
    override func viewWillAppear(_ animated: Bool) {
        getFeed()
        feedCollectionView.reloadData()
    }
}


//MARK: - Расширения Delegate, DataSorce

extension FeedViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedReturnWithOutNill.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "feedCell", for: indexPath) as? FeedCollectionViewCell else {fatalError("ERRoR!")}
        let post = feedReturnWithOutNill[indexPath.item]
        //Устанавлиывем дату
        let createTime = post.createdTime
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        dateFormatter.doesRelativeDateFormatting = true
        let time = dateFormatter.string(from: createTime)
        //Устанавливаем ячейку
        cell.set(post: post, timeOfPublishing: time)
        cell.delegate = self
        return cell
    }
}

//MARK: - Расширения FlowLayout, CellDelegate
extension FeedViewController: UICollectionViewDelegateFlowLayout, CellDelegate {
    
    // MARK: - Обновляем ленту
    func updateFeed() {
        DispatchQueue.global().async {
            self.getUser()
            self.getFeed()
            DispatchQueue.main.async {
                self.feedCollectionView.reloadData()
            }
        }
    }
    
    // MARK: - didTap on Likes (Переход по тапу на кол-во Лайков)
    func didTapOnLikes(in cell: UICollectionViewCell, currentPost: Post) {
        //Удаляем прежде загруженных пользователей с прошлой публикации
        self.unwrapdeArrayOfLikesByUsers.removeAll()
        post.usersLikedPost(with: currentPost.id, queue: DispatchQueue.global()) { (array) in
            guard array != nil else {return}
            
            DispatchQueue.main.async {
                self.unwrapdeArrayOfLikesByUsers = array ?? []
                self.getLikes()
                self.feedCollectionView.reloadData()
                
            }
        }
    }
    //Функция для перехода на списсок юзеров поставивших лайк
    func getLikes() {
        if #available(iOS 13.0, *) {
            guard let friendViewController = self.storyboard?.instantiateViewController(identifier: "FollowedByUser") as? FollowedByUser else { return }
            DispatchQueue.global().async {
                friendViewController.mainTitle = "Likes"
                friendViewController.friends = self.unwrapdeArrayOfLikesByUsers
                
                DispatchQueue.main.async {
                    self.show(friendViewController, sender: self)
                }
            }
        }
    }
    
    // MARK: - didTap on Avatar (Переход по тапу на Аватар/Имя)
    func didTap(OnAvatarIn cell: UICollectionViewCell, currentPost: Post) {
        guard let current = curUser else {return}
        user.usersFollowedByUser(with: current.id, queue: DispatchQueue.global()) { [weak self] followers in
            guard followers != nil else {return} //self?.alertMessage()
            self?.follwed = followers ?? []
            if let foll = self?.follwed {
                for user in foll {
                    if user.id == currentPost.author {
                        self?.userOfCurrentPost = user
                    } else if currentPost.author == current.id {
                        self?.userOfCurrentPost = current
                    }
                }
            }
            DispatchQueue.main.async {
                if #available(iOS 13.0, *) {
                    guard let secondViewController = self?.storyboard?.instantiateViewController(identifier: "FriendViewController") as? FriendViewController else { return }
                    secondViewController.currentFriend = self?.userOfCurrentPost
                    self?.show(secondViewController, sender: self)
                }
            }
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
