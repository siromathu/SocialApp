//
//  UserDetails.swift
//  SocialApp
//
//  Created by Siroson Mathuranga Sivarajah on 28/02/18.
//  Copyright © 2018 Siroson Mathuranga Sivarajah. All rights reserved.
//

import Foundation

struct UserDetail {
    
    // MARK:- Properties
    
    let id: Int!
    let name: String!
    let posts: String!
    let followers: String!
    let following: String!
    let place: String!
    let about: String!
    let profilePhoto: String!
    let photos: [String]!
    var isFollowing = false
}
