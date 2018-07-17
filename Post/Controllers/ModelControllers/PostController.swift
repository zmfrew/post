//
//  PostController.swift
//  Post
//
//  Created by Zachary Frew on 7/16/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import Foundation

class PostController {
    
    // MARK: - Properties
    static let baseURL = URL(string: "http://devmtn-posts.firebaseio.com/posts")!
    static let getterEndpoint = baseURL.appendingPathExtension("json")
    var posts: [Post] = []
    
    // MARK: - Methods
    func fetchPosts(reset: Bool = true, completion: @escaping() -> Void) {
        
        let queryEndInterval = reset ? Date().timeIntervalSince1970 : posts.last?.queryTimeStamp ?? Date().timeIntervalSince1970
        
        let urlParameters = [
            "orderBy": "\"timestamp\"",
            "endAt": "\(queryEndInterval)",
            "limitToLast": "15",
            ]
        
        let queryItems = urlParameters.compactMap( { URLQueryItem(name: $0.key, value: $0.value) } )
        
        var urlComponents = URLComponents(url: PostController.baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else { completion(); return }
        
        let getterEndpoint = url.appendingPathExtension("json")
        
        var request = URLRequest(url: getterEndpoint)
        request.httpBody = nil
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, _, error) in
            
            if let error = error {
                print("Error occurred: \(error.localizedDescription)")
                completion()
                return
            }
            guard let data = data else { completion(); return }
            
            do {
                let decoder = JSONDecoder()
                let postsDictionary = try decoder.decode([String : Post].self, from: data)
                let posts = postsDictionary.compactMap { $0.value }
                let sortedPosts = posts.sorted { $0.timestamp > $1.timestamp }
                if reset {
                    self.posts = sortedPosts
                } else {
                    self.posts.append(contentsOf: sortedPosts)
                }
                completion()
            } catch {
                print("Error occurred: \(error.localizedDescription)")
                completion()
            }
        })
        dataTask.resume()
        
    }
    
    func addNewPostWith(username: String, text: String, completion: @escaping() -> Void) {
        let post = Post(username: username, text: text)
        var postData: Data
        
        do {
            let encoder = JSONEncoder()
            postData = try encoder.encode(post)
        } catch {
            print("Error encoding post: \(error.localizedDescription)")
            completion()
            return
        }
        
        let postEndpoint = PostController.baseURL.appendingPathExtension("json")
    
        var request = URLRequest(url: postEndpoint)
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error occurred: \(error.localizedDescription)")
                completion()
                return
            }
            
            guard let data = data, let responseDataString = String(data: data, encoding: .utf8) else {
                print("Error occurred where data is nil")
                completion()
                return
            }
            
            self.fetchPosts {
                completion()
            }
        }
        dataTask.resume()
    }
    
}
