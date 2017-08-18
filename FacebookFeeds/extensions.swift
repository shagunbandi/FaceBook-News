//
//  extensions.swift
//  FacebookFeeds
//
//  Created by Shagun Bandi on 13/08/17.
//  Copyright © 2017 Shagun Bandi. All rights reserved.
//

import UIKit

extension UIView {
    func addConstrainsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

let imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageView: UIImageView  {
    
    var imageURLString: String?
    
    func setImageThumbnailByURL(imageURL: String) {
        imageURLString = imageURL
        let url = URL(string: imageURL)
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: imageURL as AnyObject) as? UIImage {
            self.image = imageFromCache
        }
        
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print("Error in Getting Thumbnail")
                return
            }
            DispatchQueue.main.async {
                let imageToCache = UIImage(data: data!)
                if self.imageURLString == imageURL {
                    self.image = imageToCache
                }
                imageCache.setObject(imageToCache!, forKey: imageURL as AnyObject)
            }
            
        }).resume()
    }
}

