//
//  MeatlyPost.swift
//  AC3.2-Final
//
//  Created by Tom Seymour on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation

class MeatlyPost {
    
    let postID: String
    let comment: String
    let userID: String
    
    init(postID: String, comment: String, userID: String) {
        self.postID = postID
        self.comment = comment
        self.userID = userID
    }
    
    var asDictionary: [String: String] {
        return ["comment": comment,
                "userId": userID]
    }    
}
