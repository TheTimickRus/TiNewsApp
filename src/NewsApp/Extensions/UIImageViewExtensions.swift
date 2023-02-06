//
//  UIImageViewExtensions.swift
//  NewsApp
//
//  Created by Kate on 04.02.2023.
//

import UIKit

extension UIImageView {
    private static var imageCache = NSCache<NSURL, UIImage>()

    static func setupImageCache(withCapacity capacity: Int) {
        imageCache.countLimit = capacity
    }

    func loadImage(from url: URL?, placeholder: UIImage? = UIImage(named: "placeholder")) {
        image = placeholder

        guard let url = url else { return }

        if let cachedImage = UIImageView.imageCache.object(forKey: url as NSURL) {
            image = cachedImage
            return
        }

        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    UIImageView.imageCache.setObject(image, forKey: url as NSURL)
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

