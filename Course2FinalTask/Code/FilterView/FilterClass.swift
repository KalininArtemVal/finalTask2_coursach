//
//  FilterClass.swift
//  Course2FinalTask
//
//  Created by Калинин Артем Валериевич on 26.09.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

//MARK: - Operation для обработки фильтров
class UseFilter: Operation {
    
    override var isAsynchronous: Bool {
        return true
    }
    var nameFilter: String?
    var parametr: [String: Any]
    let context = CIContext()
    var outPutImage = UIImage()
    
    init(nameFilter: String?, parametr: [String: Any]) {
        self.nameFilter = nameFilter
        self.parametr = parametr
    }
    
    override func main() {
        //функция для добавления фильтра
        guard let filter = CIFilter(name: nameFilter ?? "", parameters: parametr),
            let outputImage = filter.outputImage,
            let cgiImage = context.createCGImage(outputImage, from: outputImage.extent) else {return}
        outPutImage = UIImage(cgImage: cgiImage)
    }
}

//MARK: - Класс Filters
class Filters {
    
    let queue = OperationQueue()
    
    var newImage1 = UIImage()
    var newImage2 = UIImage()
    var newImage3 = UIImage()
    var newImage4 = UIImage()
    var newImage5 = UIImage()
    
    //MARK: - Функции вызывающие фильтры
    //1 Noir filter
    public func doNoirFilter(originalImage: UIImage, collection: UICollectionView, view: UIView) -> UIImage? {
        
        guard let ciimage = CIImage(image: originalImage) else {return nil}
        let useeFilter = UseFilter(nameFilter: "CIPhotoEffectNoir", parametr: [kCIInputImageKey: ciimage])
        queue.addOperations([useeFilter], waitUntilFinished: false)
        useeFilter.completionBlock = {
            DispatchQueue.main.async {
                self.newImage1 = useeFilter.outPutImage
                collection.reloadData()
                view.isHidden = true
            }
        }
        return newImage1
    }
    //2 Fade filter
    public func doFadeFilter(originalImage: UIImage, collection: UICollectionView) -> UIImage? {
        
        guard let ciimage = CIImage(image: originalImage) else {return nil}
        let useeFilter = UseFilter(nameFilter: "CIPhotoEffectFade", parametr: [kCIInputImageKey: ciimage])
        queue.addOperations([useeFilter], waitUntilFinished: false)
        useeFilter.completionBlock = {
            DispatchQueue.main.async {
                self.newImage2 = useeFilter.outPutImage
                collection.reloadData()
            }
        }
        return newImage2
    }
    //3 Sepia filter
    public func doSepiaFilter(originalImage: UIImage, collection: UICollectionView) -> UIImage? {
        
        guard let ciimage = CIImage(image: originalImage) else {return nil}
        let useeFilter = UseFilter(nameFilter: "CISepiaTone", parametr: [kCIInputImageKey: ciimage])
        queue.addOperations([useeFilter], waitUntilFinished: false)
        useeFilter.completionBlock = {
            DispatchQueue.main.async {
                self.newImage3 = useeFilter.outPutImage
                collection.reloadData()
            }
        }
        return newImage3
    }
    //4 Blur filter
    public func doTonalFilter(originalImage: UIImage, collection: UICollectionView) -> UIImage? {
        
        guard let ciimage = CIImage(image: originalImage) else {return nil}
        let useeFilter = UseFilter(nameFilter: "CIPhotoEffectTonal", parametr: [kCIInputImageKey: ciimage])
        queue.addOperations([useeFilter], waitUntilFinished: false)
        useeFilter.completionBlock = {
            DispatchQueue.main.async {
                self.newImage4 = useeFilter.outPutImage
                collection.reloadData()
            }
        }
        return newImage4
    }
    
    //5 Transfer filter
    public func doTransferFilter(originalImage: UIImage, collection: UICollectionView) -> UIImage? {
        guard let ciimage = CIImage(image: originalImage) else {return nil}
        let useeFilter = UseFilter(nameFilter: "CIPhotoEffectTransfer", parametr: [kCIInputImageKey: ciimage])
        queue.addOperations([useeFilter], waitUntilFinished: false)
        useeFilter.completionBlock = {
            DispatchQueue.main.async {
                self.newImage5 = useeFilter.outPutImage
                collection.reloadData()
            }
        }
        return newImage5
    }
}


