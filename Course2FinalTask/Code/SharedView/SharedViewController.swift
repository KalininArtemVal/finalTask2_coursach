//
//  ShareViewController.swift
//  Course2FinalTask
//
//  Created by Калинин Артем Валериевич on 02.10.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//
import UIKit
import DataProvider

//MARK: - SharedViewController (Экран публикации)
class SharedViewController: UIViewController {
    
    @IBOutlet weak var sharedImageView: UIImageView!
    @IBOutlet weak var sharedTextField: UITextField!
    @IBOutlet weak var sharedLable: UIBarButtonItem!
    
    static let identifire = "SharedViewController"
    let post = DataProviders.shared.postsDataProvider
    
    var sharedImage = UIImage()
    var sharedPost: Post?
    var descriptionText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSharedImage()
    }
    
    func setSharedImage() {
        sharedImageView.image = sharedImage
    }
    
    //Публикация Поста
    @IBAction func shredButton(_ sender: Any) {
        descriptionText = sharedTextField.text ?? ""
        post.newPost(with: sharedImage, description: sharedTextField.text ?? "", queue: DispatchQueue.global()) { (_) in}
        sharedTextField.text = ""
        tabBarController?.selectedIndex = 0
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
