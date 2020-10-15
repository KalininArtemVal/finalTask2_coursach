//
//  SelectFiltersViewController.swift
//  Course2FinalTask
//
//  Created by Калинин Артем Валериевич on 26.09.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider


//MARK: - Экран с коллекцией фотографий пользователя
class SelectFiltersViewController: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    static let identifire = "SelectFiltersViewController"
    
    
    
    //    let appendFilter = AppendFilter()
    let invisibleView = UIView()
    let activityIndicatorCurrent = UIActivityIndicatorView()
    
    var selectedImage: UIImage?
    var filters = [ImageToFilter]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSelectedImage()
        indicator()
        setImage()
        setLayout()
        collectionView.register(FilterCollectionViewCell.nib(), forCellWithReuseIdentifier: FilterCollectionViewCell.identifire)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    //Индикатор загрузки
    func indicator() {
        invisibleView.contentMode = .scaleAspectFit
        invisibleView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        invisibleView.backgroundColor = .black
        invisibleView.alpha = 0.7
        tabBarController?.view.addSubview(invisibleView)
        activityIndicatorCurrent.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        activityIndicatorCurrent.center = self.invisibleView.center
        activityIndicatorCurrent.startAnimating()
        activityIndicatorCurrent.color = .white
        invisibleView.addSubview(activityIndicatorCurrent)
    }
    
    //Устанавливаем изображения
    func setImage() {
        userImage.image = selectedImage
        userImage.contentMode = .scaleAspectFill
    }
    
    //Констрейнты коллекции
    func setLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 120, height: 100)
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        flowLayout.minimumInteritemSpacing = 16
        flowLayout.scrollDirection = .horizontal
        collectionView.setCollectionViewLayout(flowLayout, animated: true)
    }
    
    func setSelectedImage() {
        
        if let selectedImage = selectedImage {
            let queue = OperationQueue()
            let operationFilter = UseFilter(image: selectedImage)
            
            queue.addOperation(operationFilter)
            operationFilter.completionBlock = { [weak self] in
                guard let self = self else {return}
                DispatchQueue.main.async {
                    self.filters = operationFilter.arrayOfFilters
                    self.collectionView.reloadData()
                    self.invisibleView.isHidden = true
                }
            }
        }
    }
}


//MARK: - Расширения
extension SelectFiltersViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.identifire, for: indexPath) as? FilterCollectionViewCell else {fatalError("ERRoR!")}
        
        let filter = self.filters[indexPath.row].image
        let nameOfFilter = self.filters[indexPath.row].nameOfFilter
        guard let name = nameOfFilter else {return cell}
        guard let selectedImage = filter else {return cell}
        cell.configue(image: selectedImage, name: name)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filter = filters[indexPath.row]
        userImage.image = filter.image
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SharedViewController {
            guard let image = userImage.image else {return}
            destination.sharedImage = image
        }
    }
}

extension SelectFiltersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}


