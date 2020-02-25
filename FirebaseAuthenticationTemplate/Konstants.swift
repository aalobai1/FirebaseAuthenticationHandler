//
//  Konstants.swift
//  LocationProximityMVP
//
//  Created by Ali Alobaidi on 2/8/20.
//  Copyright © 2020 Ali Alobaidi. All rights reserved.
//

import Foundation

struct Konstants {
    struct FStore {
        struct UsersCollection {
            static let collectionName = "users"
            static let imageLinkField = "image_link"
            static let uidField = "uid"
            static let emailField = "email"
            static let displayNameField = "display_name"
            static let titleField = "title"
            static let bioField = "bio"
            static let socialMediaInfoField = "social_media"
        }
    }
    
    struct UserProperties {
        static let title = "title"
        static let email = "email"
        static let displayName = "displayName"
        static let bio = "bio"
        static let socialMediaInfo = "socialMediaInfo"
    }
}
