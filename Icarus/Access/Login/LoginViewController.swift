//
//  LoginViewController.swift
//  Icarus
//
//  Created by MacOS on 15/04/2019.
//  Copyright © 2019 MacOS. All rights reserved.
//

import UIKit
import Firebase
import RSLoadingView

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
        
        RSLoadingView.hide(from: view)
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
    
    func startSpinner() {
        let loadingView = RSLoadingView(effectType: RSLoadingView.Effect.twins)
        loadingView.mainColor = .cyan
        loadingView.shouldDimBackground = true
        loadingView.dimBackgroundColor = UIColor.black.withAlphaComponent(0.6)
        loadingView.isBlocking = true
        loadingView.shouldTapToDismiss = false
        loadingView.show(on: view)
    }
    
    // Funcion Custom spinner stop indications
    func stopSpinner() {
        RSLoadingView.hide(from: view)
    }
    
    
}
