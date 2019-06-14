//
//  LoginViewController.swift
//  Icarus
//
//  Created by MacOS on 15/04/2019.
//  Copyright © 2019 MacOS. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    // MARK: - Declarations
    //  - Var
    var loginController: LoginController!
    
    //  - Login views
    @IBOutlet weak var loginEmailInput: UITextField!
    @IBOutlet weak var loginPasswordInput: UITextField!
    
    //  - ReLogin views
    @IBOutlet weak var reLoginPasswordInput: UITextField!
    @IBOutlet weak var reLoginUserImage: UIImageView!
    @IBOutlet weak var reLoginWelcomeText: UILabel!
    @IBOutlet weak var reLoginNotThisUserButton: UIButton!
    
    //  - RecoverPassword views
    @IBOutlet weak var recoverPasswordEmailInput: UITextField!
    
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginController = LoginController.init(loginViewController: self)
    }
    

    // MARK: - Actions
    //  - Login actions
    @IBAction func loginLoginButtonTapped(_ sender: UIButton) {
        loginController.tryToLogin()
    }
    
    //  - TODO ReLogin actions
    @IBAction func reLoginNotThisUserTapped(_ sender: UIButton) {
    }
    @IBAction func reLoginLoginButtonTapped(_ sender: UIButton) {
    }
    
    //  - RecoverPassword actions
    @IBAction func recoverPasswordSendEmailTapped(_ sender: UIButton) {
        loginController.tryToRecoverPassword()
    }
    
    
}
