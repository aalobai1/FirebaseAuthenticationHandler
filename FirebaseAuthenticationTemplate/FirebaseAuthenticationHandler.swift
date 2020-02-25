//
//  FirebaseAuthenticationHandler.swift
//  LocationProximityMVP
//
//  Created by Ali Alobaidi on 2/6/20.
//  Copyright © 2020 Ali Alobaidi. All rights reserved.
//

import Foundation
import Firebase

protocol FirebaseAuthenticationHandlerDelegate {
    func userDidLogin(authUser: AuthDataResult)
    func userDidSignUp(authUser: AuthDataResult)
    func userAuthenticationDidFailWithError(error: Error)
}

enum AuthenticationCredentials {
    case Email
    case Password
}

enum AuthenticationError: Error {
    case runtimeError(String)
}

enum AuthenticationAction {
    case Login
    case SignUp
}

struct FirebaseAuthenticationHandler {
    var delegate: FirebaseAuthenticationHandlerDelegate?
    
    func authenticateUserWith(email: String, password: String, action: AuthenticationAction) {
        let auth = Auth.auth()
        switch action {
            case .SignUp:
                auth.createUser(withEmail: email, password: password) { (authUser, error) in
                    self.delegateMethods(authUser: authUser, error: error, authenticationAction: .SignUp)
            }
            case .Login:
                auth.signIn(withEmail: email, password: password) { (authUser, error) in
                    self.delegateMethods(authUser: authUser, error: error, authenticationAction: .Login)
            }
        }
    }
    
    private func delegateMethods(authUser: AuthDataResult?, error: Error?, authenticationAction: AuthenticationAction) {
        if error != nil {
            delegate?.userAuthenticationDidFailWithError(error: error!)
        } else {
            if authenticationAction == .Login {
                delegate?.userDidLogin(authUser: authUser!)
            } else {
                delegate?.userDidSignUp(authUser: authUser!)
            }
        }
    }
}
