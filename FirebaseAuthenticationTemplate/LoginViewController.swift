//
//  LoginViewController.swift
//  FirebaseAuthenticationTemplate
//
//  Created by Ali Alobaidi on 2/24/20.
//  Copyright © 2020 Ali Alobaidi. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView

class LoginViewController: AuthenticationViewController {

    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        validateFields(fieldMap: [
            .Email : emailAddressTextField,
            .Password: passwordTextField
        ]) {
            self.startLoading()
            self.firebaseAuthenticationHandler.authenticateUserWith(email: self.email, password: self.password, action: .Login)
        }
    }
}
