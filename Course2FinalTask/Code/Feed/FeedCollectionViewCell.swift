//
//  FeedCollectionViewCell.swift
//  Course2FinalTask
//
//  Created by Калинин Артем Валериевич on 22.07.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit

class FeedCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var userAvatar: UIImageView?
    @IBOutlet weak var userName: UIButton?
    @IBOutlet weak var dateOfPublishing: UILabel?
    @IBOutlet weak var postImage: UIImageView?
    
    @IBOutlet weak var countOfLikes: UIButton?
    @IBOutlet weak var heartOfLike: UIButton?
    @IBOutlet weak var descriptionTextLable: UILabel?
    
    
}
