//
//  UserManager.swift
//  LocationProximityMVP
//
//  Created by Ali Alobaidi on 2/8/20.
//  Copyright © 2020 Ali Alobaidi. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

let userPath = "gs://location-proximity-mvp.appspot.com/"

protocol UserManagerDelegate {
    func didFetchUser(user: User)
    func didCreateNewUser(user: User)
    func didFailWithError(error: Error)
    func didUpdateUser(user: User)
    func didUpdateUserImage(newImagePath: String)
}

extension UserManagerDelegate {
    func didFetchUser(user: User) {
        return
    }
    
    func didCreateNewUser(user: User) {
        return
    }
    
    func didUpdateUser(user: User) {
        return
    }
    
    func didUpdateUserImage(newImagePath: String) {
        return
    }
}

class UserManager {
    var delegate: UserManagerDelegate?
    
    func updateUser(user: User) {
        let db = Firestore.firestore()
        let collection = db.collection(Konstants.FStore.UsersCollection.collectionName)
        collection.document(user.uid).setData(user.firebaseData()) { (err) in
            if err != nil {
                self.delegate?.didFailWithError(error: err!)
            } else {
                self.delegate?.didUpdateUser(user: user)
            }
        }
    }
    
    func fetchExistingUser(authUser: AuthDataResult) {
        let db = Firestore.firestore()
        let collection = db.collection(Konstants.FStore.UsersCollection.collectionName)
        
        collection.whereField(Konstants.FStore.UsersCollection.emailField, isEqualTo: authUser.user.email!).limit(to: 1).getDocuments { (snapshot, err) in
            if err != nil {
                self.delegate?.didFailWithError(error: err!)
            } else {
                if let document = snapshot?.documents.first {
                    if document.exists {
                        self.delegate?.didFetchUser(user: User(documentSnapshot: document))
                    }
                }
            }
        }
    }
    
    // createNewUser sets default values in firebase, you're going to want to change these keys based on your defined user model
    
    func createNewUser(authUser: AuthDataResult) {
        let db = Firestore.firestore()
        let collection = db.collection(Konstants.FStore.UsersCollection.collectionName)
        
        let userRef = collection.document(authUser.user.uid)
        
        userRef.setData([
            Konstants.FStore.UsersCollection.emailField: authUser.user.email!,
            Konstants.FStore.UsersCollection.uidField: authUser.user.uid,
            Konstants.FStore.UsersCollection.bioField: "",
            Konstants.FStore.UsersCollection.displayNameField: "",
            Konstants.FStore.UsersCollection.titleField: "",
            Konstants.FStore.UsersCollection.socialMediaInfoField : [],
            Konstants.FStore.UsersCollection.imageLinkField: ""
        ]) { (error) in
            if error != nil {
                self.delegate?.didFailWithError(error: error!)
            } else {
                self.delegate?.didCreateNewUser(user: User(uid: authUser.user.uid, email: authUser.user.email!))
            }
        }
    }
}

// PROFILE IMAGE HELPERS

extension UserManager {
    func editUserImage(user: User, image: UIImage) {
        if user.imageLink.isEmpty {
            self.uploadUserImage(image: image, user: user)
        } else {
            self.deleteImage(user: user) {
                self.uploadUserImage(image: image, user: user)
            }
        }
    }
    
    func uploadUserImage(image: UIImage, user: User) {
        let storageRef = Storage.storage().reference().child("\(user.displayName)/\(UUID().uuidString).jpg")
        if let uploadData = image.jpegData(compressionQuality: 0.25) {
             storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                 if error != nil {
                     self.delegate?.didFailWithError(error: error!)
                 } else {
                     self.delegate?.didUpdateUserImage(newImagePath: userPath + metadata!.path!)
                 }
             }
         }
    }
    
    func deleteImage(user: User, completion: @escaping () -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference(forURL: user.imageLink)

        //Removes image from storage
        storageRef.delete { error in
            if let error = error {
                self.delegate?.didFailWithError(error: error)
            } else {
                completion()
            }
        }
    }
}
