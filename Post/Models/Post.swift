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
    
    init(username: String, text: String, timestamp: TimeInterval) {
        self.username = username
        self.text = text
        self.timestamp = Date().timeIntervalSince1970
    }
    
}
