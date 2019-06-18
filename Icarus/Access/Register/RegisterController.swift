//
//  RegisterController.swift
//  Icarus
//
//  Created by MacOS on 23/04/2019.
//  Copyright © 2019 MacOS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class RegisterController {
    
    // MARK: - Declarations
    // Var
    var view: RegisterViewController
    var fbAuth: Auth
    var alert: GlobalController
    var db: Firestore!
    var fbUser: FirebaseUser?
    
    // MARK: - Init()
    init(viewController: RegisterViewController) {
        self.view = viewController
        self.fbAuth = Auth.auth()
        self.alert = GlobalController.init()
        
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
    }
    
    // MARK: - Methods
    
    func tryToRegister() {
        guard let eml = user.email else { return }
        guard let pwd = user.password else { return }
        guard let name = self.view.registerNameInput?.text else { return }
        guard let city = self.view.registerCityInput?.text else { return }
        guard let sentence = self.view.registerSentenceInput?.text else { return }
        
        user.password = ""
        user.name = name
        user.city = city
        user.sentence = sentence
        
        let fbUser = FirebaseUser(name: name, city: city, sentence: sentence, hours: 0, km: 0, routesDone: 0)
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "Main")
        
        self.fbAuth.createUser(withEmail: eml, password: pwd, completion: {(user, error) in
            if error != nil {
                self.alert.showAlertOnVC(targetVC: self.view, title: "Registro Fallido", message: "El correo o la contraseñan no coinciden, intentanlo de nuevo.")
            } else {
                var ref: DocumentReference? = nil
                ref = self.db.collection("users").addDocument(data: [
                    "name" : fbUser.name,
                    "city" : fbUser.city,
                    "sentence" : fbUser.sentence,
                    "hours" : fbUser.hours,
                    "km" : fbUser.km,
                    "routesDone" : fbUser.routesDone,
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added with ID: \(ref!.documentID)")
                    }
                }
                self.view.present(vc, animated: true, completion: nil)
            }
        })
        
    }
    
    func checkEmail() {
        
        guard let eml = self.view.registerEmailInput?.text else { return }
        guard let vc: UIViewController = self.view.storyboard?.instantiateViewController(withIdentifier: "RegisterStepTwo") else { return }
        
        if eml.count >= 5 {
            self.fbAuth.fetchProviders(forEmail: eml) { (array, error) in
                if array != nil {
                    if (array?.contains("password"))! {
                        self.alert.showAlertOnVC(targetVC: self.view, title: "Correo existente", message: "Este correo ya esta registrado en la aplicación, si no recuerdas tu contraseña puedes recuperarla desde la pantalla de login.")
                    } else {
                        return
                    }
                } else {
                    user.email = eml
                    self.view.present(vc, animated: true, completion: nil)
                }
                if error != nil {
                    self.alert.showAlertOnVC(targetVC: self.view, title: "Correo no detectado", message: "Se ha producido un error al intentar comprobar el correo electronico, comprueba que esta bien escrito o intentalo con otro.")
                }
            }
        }
    }

    func checkPassword() {
        
        guard let pwd1 = self.view.registerPasswordInput?.text else { return }
        guard let pwd2 = self.view.registerPasswordRepeatInput?.text else { return }
        guard let vc: UIViewController = self.view.storyboard?.instantiateViewController(withIdentifier: "RegisterStepThree") else { return }
        
        if pwd1.count >= 6 {
            if pwd1 == pwd2 {
                user.password = pwd1
                self.view.present(vc, animated: true, completion: nil)
            } else {
                self.alert.showAlertOnVC(targetVC: self.view, title: "Contraseñas no coinciden", message: "Las contraseñas no son iguales, intentalo de nuevo.")
                return
            }
        }
    }
}
