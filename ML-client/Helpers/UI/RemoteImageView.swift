//
//  RemoteImageView.swift
//  ML-client
//
//  Created by Pablo Romero on 8/14/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import UIKit

class RemoteImageView: UIImageView {

    var spinner: UIActivityIndicatorView?
    var currentContentURL: URL?
    
    func setContent(url: URL?) {
        
        if refreshContent(forNewUrl: url) {
           
            self.cleanCurrentConfiguration()
            if let url = url {
                
                self.currentContentURL = url
                if let image = self.cachedImage(forRemoteUrl: url) {
                    self.image = image
                } else {
                    
                    self.presentLoadingMode()

                    let localUrl = self.localCachedImageUrl(forRemoteUrl: url)
                    
                    NetworkingHelper.sharedInstance.downloadContent(fromUrl: url, to: localUrl) { (remoteUrl: URL, localUrl: URL, error: Error?) in
                        DispatchQueue.main.async {
                            self.removeLoadingMode()
                            if error != nil {
                                self.presentErrorMode()
                            } else {
                                if let currentUrl = self.currentContentURL, currentUrl == url {
                                    print("downloaded \(url) to \(localUrl)")
                                    self.image = self.cachedImage(forRemoteUrl: url)!
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func refreshContent(forNewUrl newUrl: URL?) -> Bool {
        if image == nil {
            return true
        } else {
            if let currentContentURL = currentContentURL {
                return currentContentURL != newUrl
            } else {
                return true
            }
        }
    }
    
    // MARK: - Cache
    
    private func cachedImage(forRemoteUrl url: URL) -> UIImage? {
        let localUrl = localCachedImageUrl(forRemoteUrl: url)
        if FileSystemHelper.sharedInstance.existFile(atUrl: localUrl) {
            let path = localUrl.path
            return UIImage(contentsOfFile: path)
        } else {
            return nil
        }
    }
    
    private func localCachedImageUrl(forRemoteUrl url: URL) -> URL {
        var localURL = FileSystemHelper.cachesUrl()
        localURL.appendPathComponent(url.md5Hash())
        return localURL
    }
    
    // MARK: - States
    
    private func cleanCurrentConfiguration() {
        currentContentURL = nil
        image = nil
        removeLoadingMode()
    }
    
    private func presentLoadingMode() {
        image = nil
        
        if spinner == nil {
            
            let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            addSubview(spinner)
           
            spinner.startAnimating()
            spinner.center = CGPoint(x: bounds.size.width / 2.0,
                                     y: bounds.size.height / 2.0)
            
            spinner.autoresizingMask = [.flexibleBottomMargin,
                                        .flexibleLeftMargin,
                                        .flexibleRightMargin,
                                        .flexibleTopMargin]
            
            self.spinner = spinner
        }
    }
    
    private func removeLoadingMode() {
        if let spinner = spinner {
            spinner.removeFromSuperview()
            self.spinner = nil
        }
    }
    
    private func presentErrorMode() {
        image = nil
        removeLoadingMode()
    }
    
}
