////
////  Firebase.swift
////  Icarus
////
////  Created by MacOS on 18/04/2019.
////  Copyright © 2019 MacOS. All rights reserved.
////
//
//import Foundation
//import Firebase
//import UIKit
//
//class FirebaseController {
//
//    var fbAuth: Auth
//
//    init() {
//        fbAuth = Auth.auth()
//    }
//
//
//    // MARK: - Methods
//    func login(email:String, password:String, view: UIViewController) {
//
//        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "Main")
//        let alert = GlobalController.init()
//
//        fbAuth.signIn(withEmail: email, password: password, completion: {(user, error) in
//            if error != nil {
//                alert.showAlertOnVC(targetVC: view, title: "Login Fallido", message: "El correo o la contraseñan no coinciden, intentanlo de nuevo.")
//            } else {
//                view.present(vc, animated: true, completion: nil)
//            }
//        })
//    }
//
//    func register(email:String, password:String, view: UIViewController) {
//
//        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "Main")
//        let alert = GlobalController.init()
//
//        fbAuth.createUser(withEmail: email, password: password, completion: {(user, error) in
//            if error != nil {
//                alert.showAlertOnVC(targetVC: view, title: "Registro Fallido", message: "El correo o la contraseñan no coinciden, intentanlo de nuevo.")
//            } else {
//                view.present(vc, animated: true, completion: nil)
//            }
//        })
//    }
//
//    func checkEmailExist(email: String, view: UIViewController) {
//
//        let loginStoryboard = UIStoryboard(name: "LoginStoryboard", bundle: nil)
//        let vc: UIViewController = loginStoryboard.instantiateViewController(withIdentifier: "RegisterStepTwo")
//        let alert = GlobalController.init()
//
//        fbAuth.fetchProviders(forEmail: email) { (array, error) in
//            if array != nil {
//                if (array?.contains("password"))! {
//                    alert.showAlertOnVC(targetVC: view, title: "Correo existente", message: "Este correo ya esta registrado en la aplicación, si no recuerdas tu contraseña puedes recuperarla desde la pantalla de login.")
//                } else {
//                    view.present(vc, animated: true, completion: nil)
//                }
//            }
//        }
//    }
//
//    func logout() {
//        do {
//            try fbAuth.signOut()
//        } catch let signOutError as NSError {
//            print ("Error signing out: %@", signOutError)
//        }
//    }
//
//    func recoverPassword(email: String, view: UIViewController) {
//
//        let loginStoryboard = UIStoryboard(name: "LoginStoryboard", bundle: nil)
//        let vc = loginStoryboard.instantiateViewController(withIdentifier: "MainLogin")
//        let alert = GlobalController.init()
//
//        fbAuth.sendPasswordReset(withEmail: email) { (error) in
//            if error != nil {
//                alert.showAlertOnVC(targetVC: view, title: "Fallo al enviar", message: "Ha ocurrido un error al intentar mandar el correo, porfavor intentalo más tarde.")
//            } else {
//                view.present(vc, animated: true, completion: {
//                alert.showAlertOnVC(targetVC: vc, title: "Enviado", message: "El cambio de contraseña se ha enviado correctamente al " + email)
//
//                })
//            }
//
//        }
//
//    }
//
//}
