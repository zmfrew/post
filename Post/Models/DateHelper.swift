//
//  DateHelper.swift
//  Post
//
//  Created by Zachary Frew on 7/16/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import Foundation

extension Date {
    
    // MARK: Methods
    func stringValue() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }
    
}
