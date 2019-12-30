//
//  Post.swift
//  mobile-social
//
//  Created by Yi Zheng on 2019-12-29.
//  Copyright © 2019 Yi Zheng. All rights reserved.
//

import Foundation

struct Post: Decodable {
    let id: String
    let text: String
    let createdAt: Int
    let imageUrl: String
    let user: User
}

struct User: Decodable{
    let id: String
    let fullName: String
}
