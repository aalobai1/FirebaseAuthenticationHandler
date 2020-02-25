//
//  User.swift
//  LocationProximityMVP
//
//  Created by Ali Alobaidi on 2/6/20.
//  Copyright © 2020 Ali Alobaidi. All rights reserved.
//

import Foundation
import Firebase

enum SocialMediaIdentifier: String, CaseIterable, Encodable, Decodable {
    case Instagram = "Instagram"
    case Snapchat = "Snapchat"
    case Soundcloud = "Soundcloud"
    case Spotify = "Spotify"
    case AppleMusic = "AppleMusic"
}

struct SocialMediaReference: Encodable, Decodable {
    var handle: String
    var provider: SocialMediaIdentifier
    var profileLink: String
}

// Modify this User model to your specific use case

struct User {
    var uid: String
    var imageLink: String
    var email: String
    var displayName: String
    var title: String
    var bio: String
    var socialMediaInfo: [SocialMediaReference]
}

// Mark:: INITS

extension User {
    init(documentSnapshot: DocumentSnapshot) {
        self.uid = documentSnapshot.get(Konstants.FStore.UsersCollection.uidField) as! String
        self.email = documentSnapshot.get(Konstants.FStore.UsersCollection.emailField) as! String
        self.displayName = documentSnapshot.get(Konstants.FStore.UsersCollection.displayNameField) as! String
        self.imageLink = documentSnapshot.get(Konstants.FStore.UsersCollection.imageLinkField) as! String
        self.title = documentSnapshot.get(Konstants.FStore.UsersCollection.titleField) as! String
        self.bio = documentSnapshot.get(Konstants.FStore.UsersCollection.bioField) as! String
        do {
            let snapshotData = documentSnapshot.get(Konstants.FStore.UsersCollection.socialMediaInfoField) as! String
            self.socialMediaInfo = try JSONDecoder().decode([SocialMediaReference].self, from: Data(snapshotData.utf8))
        }
        catch {
            print(error)
            self.socialMediaInfo = []
        }
    }
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
        self.displayName = ""
        self.title = ""
        self.bio = ""
        self.imageLink = ""
        self.socialMediaInfo = []
    }
}

// Mark:: ENCODABLE HELPERS

extension User {
    func encodedSocialMediaInfo() -> String? {
        do {
            let jsonData = try JSONEncoder().encode(socialMediaInfo)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            
            return jsonString
        } catch { print(error); return nil }
    }
}

extension User {
    func firebaseData() -> [String:Any] {
        return [
            Konstants.FStore.UsersCollection.emailField: email,
            Konstants.FStore.UsersCollection.uidField: uid,
            Konstants.FStore.UsersCollection.bioField: bio,
            Konstants.FStore.UsersCollection.displayNameField: displayName,
            Konstants.FStore.UsersCollection.titleField: title,
            Konstants.FStore.UsersCollection.imageLinkField: imageLink,
            Konstants.FStore.UsersCollection.socialMediaInfoField : encodedSocialMediaInfo()
        ]
    }
}
