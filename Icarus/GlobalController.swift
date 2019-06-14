//
//  GlobalController.swift
//  Icarus
//
//  Created by MacOS on 23/04/2019.
//  Copyright © 2019 MacOS. All rights reserved.
//

import UIKit
import Firebase

class GlobalController {
    
    // MARK: - ShowAlertFunc
    func showAlertOnVC(targetVC: UIViewController, title: String, message: String) {
        let title = NSLocalizedString(title, comment: "")
        let message = NSLocalizedString(message, comment: "")
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(
            title:"OK",
            style: UIAlertAction.Style.default,
            handler:
            {
                (alert: UIAlertAction!)  in
        })
        alert.addAction(okButton)
        targetVC.present(alert, animated: true, completion: nil)
    }
    
}

struct RouteHistoric {
    var records: [RouteRecord]!
    
}
struct RouteRecord {
    var date: Timestamp!
    var time: Double!
    
}

class FirebaseUser {
    var name: String!
    var city: String!
    var sentence: String!
    var hours: Double!
    var km: Double!
    var routesDone: Double!
    
    var routeHistoric: [(String, RouteRecord)]?
    
    
    init(name: String, city: String, sentence: String, hours: Double, km: Double, routesDone: Double) {
        self.name = name
        self.city = city
        self.sentence = sentence
        self.hours = hours
        self.km = km
        self.routesDone = routesDone
    }
}
