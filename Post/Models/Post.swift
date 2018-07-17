//
//  Post.swift
//  Post
//
//  Created by Zachary Frew on 7/16/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import Foundation

struct Post: Codable {
    
    // MARK: - Properties
    let username: String
    let text: String
    let timestamp: TimeInterval
    
    var queryTimeStamp: TimeInterval {
        return timestamp - 0.00001
    }
    
    // MARK: - Initializers
    init(username: String, text: String, timestamp: TimeInterval = Date().timeIntervalSince1970) {
        self.username = username
        self.text = text
        self.timestamp = timestamp
    }
    
    
    
}
