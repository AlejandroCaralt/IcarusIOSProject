//
//  LoginControlller.swift
//  Icarus
//
//  Created by MacOS on 18/04/2019.
//  Copyright © 2019 MacOS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import Mapbox
import MapboxDirections
import RSLoadingView

class LoginController {
    
    // MARK: - Declarations
    // Var
    var view: LoginViewController
    var fbAuth: Auth
    var alert: GlobalController
    
    var ownRoutes: [FirebaseRoute?]! = []
    
    var firebaseUser: FirebaseUser!
    
    // MARK: - Init()
    init(loginViewController: LoginViewController) {
        view = loginViewController
        fbAuth = Auth.auth()
        alert = GlobalController.init()
        
    }
    
    // MARK: - Methods
    func tryToLogin() {
        view.startSpinner()
        guard let eml = view.loginEmailInput.text else { return }
        guard let pwd = view.loginPasswordInput.text else { return }
        let storyboard:UIStoryboard = UIStoryboard(name: "DashboardStoryboard", bundle: nil)
        let vc =  try storyboard.instantiateViewController(withIdentifier: "Dashboard") as! MainViewController

        if eml.count >= 5 && pwd.count >= 6 {
            
            fbAuth.signIn(withEmail: eml, password: pwd, completion: {(user, error) in
                if error != nil {
                    self.view.stopSpinner()
                    self.alert.showAlertOnVC(targetVC: self.view, title: "Login Fallido", message: "El correo o la contraseñan no coinciden, intentanlo de nuevo.")
                } else {
                    self.view.stopSpinner()
                    vc.getUserRouteData()
                    self.view.present(vc, animated: false, completion: nil)
                }
            })
            
        } else {
            return
        }

    }
    
    
    
    
    
    
    
    func tryToRecoverPassword() {
        
        guard let eml = view.loginEmailInput.text else {
            return
        }
        
        guard let vc = view.storyboard?.instantiateViewController(withIdentifier: "MainLogin") else {
            return
        }
        
        if eml.count >= 5 {
            fbAuth.sendPasswordReset(withEmail: eml) { (error) in
                if error != nil {
                    self.alert.showAlertOnVC(targetVC: vc, title: "Fallo al enviar", message: "Ha ocurrido un error al intentar mandar el correo, porfavor intentalo más tarde.")
                } else {
                    self.view.present(vc, animated: true, completion: {
                        self.alert.showAlertOnVC(targetVC: vc, title: "Enviado", message: "El cambio de contraseña se ha enviado correctamente al " + eml)
                        
                    })
                }
                
            }
        } else {
            return
        }
        
    }
    
}
