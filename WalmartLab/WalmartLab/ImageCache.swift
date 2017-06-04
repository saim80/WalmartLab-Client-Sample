//
//  ImageCache.swift
//  WalmartLab
//
//  Created by Sangwoo Im on 4/30/17.
//  Copyright © 2017 Sangwoo Im. All rights reserved.
//

import Foundation
import UIKit

class ImageCache : NSObject {
    let cache = NSCache<NSURL,UIImage>()
    let opQueue = OperationQueue()
    var pendingOps = [URL:ImageCacheOperation]()

    static let shared = ImageCache()

    override init() {
        super.init()

        opQueue.maxConcurrentOperationCount = 5
        opQueue.qualityOfService = .default
        opQueue.name = "com.walmartlab.image-cache"
    }

    func loadImage(imageURL:URL, block:@escaping (UIImage?, Error?)->Void) {
        if let image = cache.object(forKey: imageURL as NSURL) {
            DispatchQueue.main.async {
                block(image, nil)
            }
        } else if let pendingOp = pendingOps[imageURL] {
            pendingOp.completionBlocks.append(block)
        } else {
            let loadOp = ImageCacheOperation(imageURL: imageURL, completion: block)

            pendingOps[imageURL] = loadOp

            loadOp.resume()
        }
    }
}

class ImageCacheOperation : BlockOperation {
    var imageURL:URL

    var error:Error?
    var image:UIImage?
    var downloadTask:URLSessionDownloadTask?
    var completionBlocks = [(UIImage?, Error?) -> Void]()

    enum CacheError : Error {
        case invalidData
        case fileIO
    }

    init(imageURL:URL, completion:@escaping (UIImage?, Error?)->Void) {
        self.imageURL = imageURL
        super.init()

        self.completionBlocks.append(completion)

        self.addExecutionBlock { [weak self] in
            guard let strongSelf = self else { return }
            // omitting file level cache for simplicity
            if let image = strongSelf.image {
                ImageCache.shared.cache.setObject(image, forKey: strongSelf.imageURL as NSURL)
            }
        }

        self.completionBlock = { [weak self] in
            guard let strongSelf = self else { return }

            DispatchQueue.main.sync {
                for block in strongSelf.completionBlocks {
                    block(strongSelf.image, strongSelf.error)
                }
                ImageCache.shared.pendingOps.removeValue(forKey: strongSelf.imageURL)
            }
        }
    }

    override func cancel() {
        super.cancel()
        self.downloadTask?.cancel()
    }

    func resume() {
        downloadTask = URLSession.shared.downloadTask(with: imageURL,
                                                      completionHandler:
            { [weak self] (tempURL:URL?, response:URLResponse?, error:Error?) in
                guard let strongSelf = self else { return }

                if let error = error {
                    strongSelf.error = error
                } else if let tempURL = tempURL {
                    if let data = try? Data(contentsOf: tempURL) {
                        strongSelf.image = UIImage(data: data)
                    } else {
                        strongSelf.error = CacheError.invalidData
                    }
                } else {
                    strongSelf.error = CacheError.fileIO
                }

                ImageCache.shared.opQueue.addOperation(strongSelf)
            }
        )

        downloadTask?.resume()
    }
}
