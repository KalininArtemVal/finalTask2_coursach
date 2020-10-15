//
//  FilterClass.swift
//  Course2FinalTask
//
//  Created by Калинин Артем Валериевич on 26.09.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

var a = [UIImage]()

var arrayWithFilter = [ImageToFilter]()

//MARK: - Operation для обработки фильтров
class UseFilter: Operation {
    
    override var isAsynchronous: Bool {
        return true
    }
    var image: UIImage?
    let context = CIContext()
    var outPutImage = UIImage()
    
    var filtredImage1 = UIImage()
    var filtredImage2 = UIImage()
    var filtredImage3 = UIImage()
    var filtredImage4 = UIImage()
    var filtredImage5 = UIImage()
    
    var first: ImageToFilter?
    var second: ImageToFilter?
    var third: ImageToFilter?
    var forth: ImageToFilter?
    var fifth: ImageToFilter?
    
    var arrayOfFilters = [ImageToFilter]()
    
    init(image: UIImage?) {
        self.image = image
    }
    
    override func main() {
        //Создаем структуры фильтров
        guard let image = image else {return}
        guard let ciimage = CIImage(image: image) else {return}
        
        //"Noir"
        guard let filter = CIFilter(name: "CIPhotoEffectNoir", parameters: [kCIInputImageKey: ciimage]),
            let outputImage = filter.outputImage,
            let cgiImage = context.createCGImage(outputImage, from: outputImage.extent) else {return}
        filtredImage1 = UIImage(cgImage: cgiImage)
        first = ImageToFilter(image: filtredImage1, nameOfFilter: "Noir")
        
        //"Fade"
        guard let filter1 = CIFilter(name: "CIPhotoEffectFade", parameters: [kCIInputImageKey: ciimage]),
            let outputImage1 = filter1.outputImage,
            let cgiImage1 = context.createCGImage(outputImage1, from: outputImage1.extent) else {return}
        filtredImage2 = UIImage(cgImage: cgiImage1)
        second = ImageToFilter(image: filtredImage2, nameOfFilter: "Fade")
        
        //"SepiaTone"
        guard let filter2 = CIFilter(name: "CISepiaTone", parameters: [kCIInputImageKey: ciimage]),
            let outputImage2 = filter2.outputImage,
            let cgiImage2 = context.createCGImage(outputImage2, from: outputImage2.extent) else {return}
        filtredImage3 = UIImage(cgImage: cgiImage2)
        third = ImageToFilter(image: filtredImage3, nameOfFilter: "SepiaTone")
        
        //"Noir"
        guard let filter3 = CIFilter(name: "CIPhotoEffectTonal", parameters: [kCIInputImageKey: ciimage]),
            let outputImage3 = filter3.outputImage,
            let cgiImage3 = context.createCGImage(outputImage3, from: outputImage3.extent) else {return}
        filtredImage3 = UIImage(cgImage: cgiImage3)
        forth = ImageToFilter(image: filtredImage3, nameOfFilter: "Tonal")
        
        //"Noir"
        guard let filter4 = CIFilter(name: "CIPhotoEffectTransfer", parameters: [kCIInputImageKey: ciimage]),
            let outputImage4 = filter4.outputImage,
            let cgiImage4 = context.createCGImage(outputImage4, from: outputImage4.extent) else {return}
        filtredImage3 = UIImage(cgImage: cgiImage4)
        fifth = ImageToFilter(image: filtredImage3, nameOfFilter: "Transfer")
        
        //Разворачиваем структуры
        guard let first = first else {return}
        guard let second = second else {return}
        guard let third = third else {return}
        guard let forth = forth else {return}
        guard let fifth = fifth else {return}
        
        //добавляем структувы в массив
        arrayOfFilters = [first, second, third, forth, fifth]
    }
}
