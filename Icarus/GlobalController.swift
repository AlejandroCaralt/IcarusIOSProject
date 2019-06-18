//
//  GlobalController.swift
//  Icarus
//
//  Created by MacOS on 23/04/2019.
//  Copyright © 2019 MacOS. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import FirebaseFirestore

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

class FirebaseUser {
    var name: String!
    var city: String!
    var sentence: String!
    var hours: Double!
    var km: Double!
    var routesDone: Double!
    
    
    init(name: String, city: String, sentence: String, hours: Double, km: Double, routesDone: Double) {
        self.name = name
        self.city = city
        self.sentence = sentence
        self.hours = hours
        self.km = km
        self.routesDone = routesDone
    }
   
}

struct FirebaseRoute {
    var routeCoordinates: [CLLocationCoordinate2D]!
    var km: Double!
    var owner: String!
    var highestPoint: Double!
    var lowestPoint: Double!
    var time: Double!
    var typeRoute: String!
    var name: String!
    var id: String!
    var startPoint: CLLocationCoordinate2D!
    
    init() { }
    
    init(routeCoordinates: [CLLocationCoordinate2D], km: Double, owner: String, highestPoint: Double, lowestPoint: Double, time: Double, typeRoute: String, name: String, id: String) {
        self.routeCoordinates = routeCoordinates
        self.km = km
        self.owner = owner
        self.highestPoint = highestPoint
        self.lowestPoint = lowestPoint
        self.time = time
        self.typeRoute = typeRoute
        self.name = name
        self.id = id
        self.startPoint = CLLocationCoordinate2D(latitude: routeCoordinates[0].latitude, longitude: routeCoordinates[0].longitude)
    }
    
}

