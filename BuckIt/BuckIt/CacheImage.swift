//
//  CacheImage.swift
//  BuckIt
//
//  Created by WilliamH on 5/1/18.
//  Copyright © 2018 Samnang Sok. All rights reserved.
//

import Foundation
import UIKit

class CacheImage {
    static let cachedImage = NSCache<NSString, UIImage>()
    
    static func downloadImage(withURL url:URL, completion: @escaping (_ image:UIImage?) -> ()) {
        let dataTask = URLSession.shared.dataTask(with: url) { data, responseURL, error in
            var downloadedImage:UIImage?
            
            if let data = data {
                downloadedImage = UIImage(data:data)
            }
            
            if downloadedImage != nil {
                cachedImage.setObject(downloadedImage!, forKey: url.absoluteString as NSString)
            }
            
            DispatchQueue.main.async {
                completion(downloadedImage)
            }
        }
        dataTask.resume()
    }
    
    static func getImage(withURL url:URL, completion: @escaping (_ image:UIImage?) -> ()) {
        if let image = cachedImage.object(forKey: url.absoluteString as NSString) {
            completion(image)
        } else {
            downloadImage(withURL: url, completion: completion)
        }
    }
}
