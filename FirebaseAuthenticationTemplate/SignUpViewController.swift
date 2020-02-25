//
//  SignUpViewController.swift
//  FirebaseAuthenticationTemplate
//
//  Created by Ali Alobaidi on 2/24/20.
//  Copyright © 2020 Ali Alobaidi. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: AuthenticationViewController {
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          self.view.endEditing(true)
      }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        do {
            try checkPassword()
            
            validateFields(fieldMap: [.Email : emailAddressTextField, .Password : passwordTextField]) {
                self.startLoading()
                self.firebaseAuthenticationHandler.authenticateUserWith(email: self.email, password: self.password, action: .SignUp)
            }
            
        } catch (let error) {
            let validationError = error as! ValidationError
            alert(message: validationError.message)
        }
    }
}

extension SignUpViewController {
    func checkPassword() throws {
        if let password = passwordTextField.text,
            let confirmedPassword = confirmPasswordTextField.text {
            if (password != confirmedPassword) {
                throw ValidationError("Passwords must match")
            }
        } else {
            throw ValidationError("Passwords cannot be empty")
        }
    }
}
