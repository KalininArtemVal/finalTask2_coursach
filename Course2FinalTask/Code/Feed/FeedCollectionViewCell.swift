//
//  FeedCollectionViewCell.swift
//  Course2FinalTask
//
//  Created by Калинин Артем Валериевич on 22.07.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

protocol CellDelegate: UIViewController {
    func didTap(OnAvatarIn cell: UICollectionViewCell)
}

class FeedCollectionViewCell: UICollectionViewCell {
    
    
    weak var delegate: CellDelegate?
    
    @IBOutlet weak var userAvatar: UIImageView?
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var dateOfPublishing: UILabel?
    @IBOutlet weak var postImage: UIImageView?
    
    @IBOutlet weak var countOfLikes: UILabel!
    
    @IBOutlet weak var heartOfLike: UIButton?
    @IBOutlet weak var descriptionTextLable: UILabel?
    @IBOutlet weak var imageHeartOfLike: UIImageView!
    
    @IBOutlet weak var bigHeart: UIImageView!
    
    static let identifire = "feedCell"
    
    var currentFriend: User?
    var currentPost: Post?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Тап на аватар и имя
        let touchUserAvatar = UITapGestureRecognizer(target: self, action: #selector(tapAvatar(sender:)))
        userAvatar?.isUserInteractionEnabled = true
        userAvatar?.addGestureRecognizer(touchUserAvatar)
        
        //Ставим лайк от маленького сердца
        let touchLitleHeart = UITapGestureRecognizer(target: self, action: #selector(tapHeart(sender:)))
        touchLitleHeart.numberOfTapsRequired = 1
        bigHeart.isHidden = true
        imageHeartOfLike?.isUserInteractionEnabled = true
        imageHeartOfLike?.addGestureRecognizer(touchLitleHeart)
        
        //устанавливаем большое сердце
        let touchPost = UITapGestureRecognizer(target: self, action: #selector(tapPost(sender:)))
        touchPost.numberOfTapsRequired = 2
        bigHeart.isHidden = true
        postImage?.isUserInteractionEnabled = true
        postImage?.addGestureRecognizer(touchPost)
    }
    
    @objc func tapHeart(sender: UITapGestureRecognizer) {
        let voice = 1
        guard var countLike = currentPost?.likedByCount else {return}
        if currentPost?.currentUserLikesThisPost == false {
            currentPost?.currentUserLikesThisPost = true
            imageHeartOfLike.image = #imageLiteral(resourceName: "like")
            imageHeartOfLike.tintColor = .systemBlue
            countLike += voice
            countOfLikes?.text = String(countLike)
            currentPost?.likedByCount = countLike
        } else {
            currentPost?.currentUserLikesThisPost = false
            imageHeartOfLike.image = #imageLiteral(resourceName: "like")
            imageHeartOfLike.tintColor = .lightGray
            countLike -= voice
            currentPost?.likedByCount = countLike
            countOfLikes?.text = String(countLike)
            print("Unliked post")
        }
    }
    
        
        @objc func tapAvatar(sender: UITapGestureRecognizer) {
            let vc = FeedCollectionViewCell()
            delegate?.didTap(OnAvatarIn: vc)
            
        }
    
    
    @objc func tapPost(sender: UITapGestureRecognizer) {
        let voice = 1
        guard var countLike = currentPost?.likedByCount else {return}
        if currentPost?.currentUserLikesThisPost == false {
            currentPost?.currentUserLikesThisPost = true
            bigHeart.isHidden = false
            imageHeartOfLike.image = #imageLiteral(resourceName: "like")
            imageHeartOfLike.tintColor = .systemBlue
            countLike += voice
            currentPost?.likedByCount = countLike
            countOfLikes?.text = String(countLike)
            UIView.animate(withDuration: 2) {
                self.bigHeart.layer.opacity = 0.0
            }
        }
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "FeedCollectionViewCell", bundle: nil)
    }
    

}
