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
    static let baseURL = URL(string: "https://dm-post.firebaseio.com/posts.json")
    var posts: [Post] = []
    
    // MARK: - Methods
    func fetchPosts(completion: @escaping() -> Void) {
        guard let baseURL = PostController.baseURL else { return }
        let getterEndpoint = baseURL.appendingPathComponent("json")
        
        let request = URLRequest(url: getterEndpoint)
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error occurred: \(error.localizedDescription)")
                return
            }
            guard let data = data else { completion(); return }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                let postsDictionary = try jsonDecoder.decode([String : Post].self, from: data)
                let posts = postsDictionary.compactMap { $0.value }
                let sortedPosts = posts.sorted { $0.timestamp > $1.timestamp }
                self.posts = sortedPosts
                completion()
            } catch {
                print("Error occurred: \(error.localizedDescription)")
                completion()
                return
            }
        
        }
        dataTask.resume()
        
    }
    
    
}
