//
//  NetworkingHelper.swift
//  ML-client
//
//  Created by Pablo Romero on 8/12/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import UIKit

typealias JSON = [String: AnyObject]

class NetworkingHelper: NSObject {

    public static let sharedInstance: NetworkingHelper = NetworkingHelper()
    private lazy var sharedSession = URLSession.shared

    // MARK: - GET
    
    public func get(baseURL: String, path: String, params: [String: String], completionHandler: @escaping ((Any?, Error?) -> Void)) {
    
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let url = NetworkingHelper.buildURL(baseURL: baseURL, path: path, params: params)
        
        var request = URLRequest(url: url)
        request.cachePolicy = .useProtocolCachePolicy

        let dataTask = sharedSession.dataTask(with: request) { (data, response, error) in
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            if error != nil {
                completionHandler(nil, error)
            }
            else {
                
                var json: Any?
                var parseError: Error?
            
                do {
                    json = try JSONSerialization.jsonObject(with: data!)
                } catch {
                    parseError = error
                }
                
                completionHandler(json, parseError)
            }
        }
        
        dataTask.resume()
    }
    
    private static func buildURL(baseURL: String, path: String, params: [String: String]) -> URL {
        var queryItems = [URLQueryItem]()
      
        for (key, value) in params {
            let queryItem = URLQueryItem(name: key, value: value)
            queryItems.append(queryItem)
        }
        
        var urlComponents = URLComponents(string: "\(baseURL)/\(path)")!
        urlComponents.queryItems = queryItems
        
        return urlComponents.url!
    }
    
    // MARK: - Download
    
    public func downloadContent(fromUrl url: URL, to localUrl: URL, completionHandler: @escaping (URL, URL, Error?) -> Void) {
        
        let downloadTask = self.sharedSession.downloadTask(with: url) { (downloadedUrl, response, error) in
            
            if error == nil {
                FileSystemHelper.sharedInstance.copyFile(atUrl: downloadedUrl!, toUrl: localUrl)
            }
            
            completionHandler(url, localUrl, error)
        }
        
        downloadTask.resume()
    }
    
}
