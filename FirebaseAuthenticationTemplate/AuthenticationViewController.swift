//
//  AuthenticatedViewController.swift
//  LocationProximityMVP
//
//  Created by Ali Alobaidi on 2/8/20.
//  Copyright © 2020 Ali Alobaidi. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView

class AuthenticationViewController: UIViewController {
    var email: String!
    var password: String!
    
    var firebaseAuthenticationHandler = FirebaseAuthenticationHandler()
    var userManager = UserManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firebaseAuthenticationHandler.delegate = self
        userManager.delegate = self
        configureKeyboard()
    }
}

extension AuthenticationViewController {
    func validateFields(fieldMap: [AuthenticationCredentials:UITextField], completion: @escaping () -> Void) {
        do {
            try fieldMap.forEach { (credential, textField) in
                if credential == .Email {
                    self.email = try textField.validatedText(validationType: ValidatorType.email)
                }
                
                if credential == .Password {
                    self.password = try textField.validatedText(validationType: ValidatorType.password)
                }
            }
            completion()
        } catch (let error) {
            let validationError = error as! ValidationError
            alert(message: validationError.message)
        }
    }
}

extension AuthenticationViewController: FirebaseAuthenticationHandlerDelegate {
    func userDidLogin(authUser: AuthDataResult) {
        stopLoading()
        userManager.fetchExistingUser(authUser: authUser)
    }
    
    func userDidSignUp(authUser: AuthDataResult) {
        stopLoading()
        userManager.createNewUser(authUser: authUser)
    }
    
    func userAuthenticationDidFailWithError(error: Error) {
        stopLoading()
        alert(message: error.localizedDescription)
    }
}

extension AuthenticationViewController: UserManagerDelegate {
    func didFetchUser(user: User) {
        print("fetched user")
    }
    
    func didCreateNewUser(user: User) {
        print("created new user")
    }
    
    func didFailWithError(error: Error) {
        alert(message: error.localizedDescription)
        return
    }
}

extension AuthenticationViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
