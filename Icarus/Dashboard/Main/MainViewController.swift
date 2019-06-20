//
//  MainViewController.swift
//  Icarus
//
//  Created by MacOS on 11/06/2019.
//  Copyright © 2019 MacOS. All rights reserved.
//

import UIKit
import Mapbox
import MapboxDirections
import RSLoadingView
import Firebase
import FirebaseFirestore

class MainViewController: UIViewController {
    
    // MARK: Variables
    
    // Container views
    @IBOutlet weak var routesCircle: UIView!
    @IBOutlet weak var kmCircle: UIView!
    @IBOutlet weak var minCircle: UIView!
    @IBOutlet weak var routesLabel: UILabel!
    @IBOutlet weak var kmLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    
    // Data to charge
    @IBOutlet weak var routesNumber: UILabel!
    @IBOutlet weak var kmNumber: UILabel!
    @IBOutlet weak var minNumber: UILabel!
    
    @IBOutlet weak var tusRutasLabel: UILabel!
    
    @IBOutlet weak var tableVIew: UIView!
    var ownRoutes: [FirebaseRoute]! = []
    var allRoutes: [FirebaseRoute]! = []
    var allRouteFeatures: [MGLShape]! = []

    var firebaseUser: FirebaseUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.onSetUp()
        
    }
    

    func putDashboardStyle() {
    
        self.routesCircle.layer.cornerRadius = self.routesCircle.bounds.width / 2
        self.routesCircle.layer.borderWidth = 4
        self.routesCircle.layer.borderColor = UIColor.black.withAlphaComponent(0.7).cgColor
        self.routesLabel.text = String(format: "%.0f", self.firebaseUser.routesDone)
        
        self.kmCircle.layer.cornerRadius = self.kmCircle.bounds.width / 2
        self.kmCircle.layer.borderWidth = 5
        self.kmCircle.layer.borderColor =  UIColor.black.withAlphaComponent(0.7).cgColor
        self.kmLabel.text = String(format: "%.2f", self.firebaseUser.km)

        
        self.minCircle.layer.cornerRadius = self.minCircle.bounds.width / 2
        self.minCircle.layer.borderWidth = 4
        self.minCircle.layer.borderColor =  UIColor.black.withAlphaComponent(0.7).cgColor
        self.minLabel.text = String(format: "%.2f", self.firebaseUser.hours)

    }
    
    func onSetUp() {

        let db = Firestore.firestore()
        let userID = String(Auth.auth().currentUser!.uid)
        
        DispatchQueue.main.async {
            // Getting user data
            db.collection("users").document(userID).addSnapshotListener { (snapshot, error) in
                if let err = error {
                    print(err.localizedDescription)
                    return
                }
                
                if let data = snapshot?.data() {
                    let name = data["name"] as! String
                    let hours = data["hours"] as! Double
                    let km = data["km"] as! Double
                    let city = data["city"] as! String
                    let routesDone = data["routesDone"] as! Double
                    let sentence = data["sentence"] as! String
                    
                    self.firebaseUser = FirebaseUser(name: name, city: city, sentence: sentence, hours: hours, km: km, routesDone: routesDone)
                }
                self.putDashboardStyle()
                
            }
            
        }

    }
    func getData() {
        
        let db = Firestore.firestore()
        let userID = String(Auth.auth().currentUser!.uid)
        
        DispatchQueue.main.async {
            // Getting user data
            db.collection("users").document(userID).addSnapshotListener { (snapshot, error) in
                if let err = error {
                    print(err.localizedDescription)
                    return
                }
                
                if let data = snapshot?.data() {
                    let name = data["name"] as! String
                    let hours = data["hours"] as! Double
                    let km = data["km"] as! Double
                    let city = data["city"] as! String
                    let routesDone = data["routesDone"] as! Double
                    let sentence = data["sentence"] as! String
                    
                    self.firebaseUser = FirebaseUser(name: name, city: city, sentence: sentence, hours: hours, km: km, routesDone: routesDone)
                }
                
            }
            
        }
        
        
    }
    
    func getUserRouteData() {
        // Getting users route data
        
        let db = Firestore.firestore()
        let userID = String(Auth.auth().currentUser!.uid)
        
        DispatchQueue.main.async {
            db.collection("routes").whereField("owner", isEqualTo: userID).getDocuments() { (snapshot, error) in
                if let err = error {
                    print(err.localizedDescription)
                    return
                }
                var index = 0
                
                for document in snapshot!.documents {
                    
                    index += 1
                    print("\(document.documentID) => \(document.data())")
                    
                    let highestPoint = document["highestPoint"] as! Double
                    let km = document["km"] as! Double
                    let lowestPoint = document["lowestPoint"] as! Double
                    let owner = document["owner"] as! String
                    let routeCoordinates = document["routesCoordinates"] as! [GeoPoint]
                    let time = document["time"] as! Double
                    let typeRoute = document["typeRoute"] as! String
                    let name = document["name"] as! String
                    let id = document.documentID
                    
                    let route: FirebaseRoute = FirebaseRoute(routeCoordinates: routeCoordinates, km: km, owner: owner, highestPoint: highestPoint, lowestPoint: lowestPoint, time: time, typeRoute: typeRoute, name: name, id: id)
                    
                    self.ownRoutes.append(route)
                    
                    
                }
                // Conditional for "Tus rutas" label when user doestn have one
                if self.ownRoutes.count == 0 {
                    self.tusRutasLabel.text = "¡Haz tu propia Ruta!"
                }
                
                self.tableViewInstantiate(routes: self.ownRoutes as! [FirebaseRoute])
                
            }
            
        }
        
    }
    
    func tableViewInstantiate(routes: [FirebaseRoute]) {
        guard let childVC = self.storyboard?.instantiateViewController(withIdentifier: "TableView") as? RouteTableViewController else {
            return
        }
        
        childVC.ownRoutes = routes
        addChildViewController(childVC)
        //Or, you could add auto layout constraint instead of relying on AutoResizing contraints
        childVC.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        childVC.view.frame = self.tableVIew.bounds
        
        tableVIew.addSubview(childVC.view)
        childVC.didMove(toParentViewController: self)
        
    }
    
    
    @IBAction func onRoutesPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "MapStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "StoreLocatorMap") as! StoreLocatorViewController
        vc.allRoutes = self.allRoutes
        vc.allRouteFeatures = self.allRouteFeatures
        vc.user = self.firebaseUser
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onProfilePressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        vc.user = self.firebaseUser
        self.present(vc, animated: true, completion: nil)
    }
    
    // MARK: Instantiate GeoJson objects
    func objectToGeojson() {
        var index = 0
        for n in allRoutes {
            
            let coord = [n.startPoint.latitude, n.startPoint.longitude]
            let nam = n.name
            
            let route = RoutePoint(geometry: geometry(coordinates: coord), properties: properties(name: nam!, index: index))
            
            let jsonData = try! JSONEncoder().encode(route)
            let data: Data = jsonData
            let shape = try! MGLShape(data: data, encoding: String.Encoding.utf8.rawValue)
            
            self.allRouteFeatures.append(shape)
            
            index += 1
            
        }
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


class RouteTableViewCell: UITableViewCell {
    @IBOutlet weak var themeImageView: UIImageView!
    @IBOutlet weak var themeMarkerImageView: UIImageView!
    @IBOutlet weak var routeDirection: UILabel!

}

class RouteTableViewController: UITableViewController {
    
    var ownRoutes: [FirebaseRoute!]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        tableView.tableFooterView = UIView()
    }
    

    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ownRoutes.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let theme = MBXTheme.themes[1]
        
        
        // Creating the cells
        let cell = tableView.dequeueReusableCell(withIdentifier: "example", for: indexPath) as! RouteTableViewCell

        
        cell.themeImageView = UIImageView(image: UIImage(named: "LoginBackground"))
        
        cell.themeMarkerImageView.image = theme.defaultMarker
        
        cell.routeDirection.text = self.ownRoutes?[indexPath.row]?.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "MapStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainRouteMap") as! MainMapViewController
        let coordinates = self.ownRoutes![indexPath.row]?.routeCoordinates
        vc.allCoordinates = coordinates
        vc.route = self.ownRoutes![indexPath.row]
        self.present(vc, animated: true, completion: nil)
    }
}



