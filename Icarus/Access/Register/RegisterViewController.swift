//
//  RegisterViewController.swift
//  Icarus
//
//  Created by MacOS on 23/04/2019.
//  Copyright © 2019 MacOS. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    // MARK: - Declarations
    // Var
    var registerController: RegisterController!
    
    // - Register First Step
    @IBOutlet weak var registerEmailInput: UITextField?
    
    // - Register Second Step
    @IBOutlet weak var registerPasswordInput: UITextField?
    @IBOutlet weak var registerPasswordRepeatInput: UITextField?
    
    // - Register Third Step
    @IBOutlet weak var registerNameInput: UITextField?
    @IBOutlet weak var registerCityInput: UITextField?
    @IBOutlet weak var registerSentenceInput: UITextField?
    
    

    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        registerController = RegisterController.init(viewController: self)
        
    }
    // MARK: - Actions
    @IBAction func registerEmailButtonTapped(_ sender: UIButton) {
        registerController.checkEmail()
    }
    @IBAction func registerPasswordButtonTapped(_ sender: UIButton) {
        registerController.checkPassword()
    }
    @IBAction func registerRegisterCompleteButtonTapped(_ sender: UIButton) {
        registerController.tryToRegister()
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
