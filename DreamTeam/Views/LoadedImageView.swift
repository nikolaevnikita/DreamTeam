//
//  LoadedImageView.swift
//  DreamTeam
//
//  Created by Николаев Никита on 21.02.2021.
//

import UIKit

class LoadedImageView: UIImageView {
    // MARK: - Private properties
    private static let imageCache = NSCache<NSURL, UIImage>()
    private var task: URLSessionTask!
    
    // MARK: - Public methods
    func loadImage(from url: URL) {
        if let task = task {
            task.cancel()
        }
        if let imageFromCache = LoadedImageView.imageCache.object(forKey: url as NSURL) {
            image = imageFromCache
            return
        }
        task = URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data,
                  let newImage = UIImage(data: data) else { return }
            LoadedImageView.imageCache.setObject(newImage, forKey: url as NSURL)
            DispatchQueue.main.async {
                self.image = newImage
            }
        }
        task.resume()
    }
}
