//
//  MainMapViewController.swift
//  Icarus
//
//  Created by MacOS on 23/05/2019.
//  Copyright © 2019 MacOS. All rights reserved.
//

import UIKit
import Mapbox
import Firebase
import FirebaseFirestore

class MainMapViewController: UIViewController, MGLMapViewDelegate {

    @IBOutlet weak var mapView: MGLMapView!
    var timer: Timer?
    var viewControllerTheme : Theme? = MBXTheme.grayTheme
        var polylineSource: MGLShapeSource?
    var currentIndex: Int!
        var allCoordinates: [CLLocationCoordinate2D]!
    var route: FirebaseRoute!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            

            mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            mapView.setCenter(
                allCoordinates[0],
                zoomLevel: 15,
                animated: false)
            
            mapView.delegate = self
            
            addBackButton()
            deleteButton()
        }
        
        // Wait until the map is loaded before adding to the map.
        func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
            addPolyline(to: mapView.style!)
            animatePolyline()
        }
    
        
        func addPolyline(to style: MGLStyle) {
            // Add an empty MGLShapeSource, we’ll keep a reference to this and add points to this later.
            let source = MGLShapeSource(identifier: "polyline", shape: nil, options: nil)
            style.addSource(source)
            polylineSource = source
            
            // Add a layer to style our polyline.
            let layer = MGLLineStyleLayer(identifier: "polyline", source: source)
            layer.lineJoin = NSExpression(forConstantValue: "round")
            layer.lineCap = NSExpression(forConstantValue: "round")
            layer.lineColor = NSExpression(forConstantValue: viewControllerTheme?.themeColor.primaryDarkColor)
            
            // The line width should gradually increase based on the zoom level.
            layer.lineWidth = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)",
                                           [14: 5, 18: 20])
            style.addLayer(layer)
        }
    
    func addBackButton() {
        let button = UIButton(type: UIButton.ButtonType.system) as UIButton
        
        button.frame = CGRect(x:view.bounds.width / 15, y:view.bounds.height / 15, width:50 , height: 50)
        button.setImage(UIImage(named: "left-arrow"), for: UIControl.State.normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.withAlphaComponent(0.7).cgColor
        button.tintColor = viewControllerTheme?.themeColor.primaryDarkColor
        button.addTarget(self, action: #selector(self.buttonAction(_:)), for: .touchUpInside)
        
        self.view.addSubview(button)
    }
    @objc func buttonAction(_ sender:UIButton!)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func deleteButton() {
        let button = UIButton(type: UIButton.ButtonType.system) as UIButton
        
        button.frame = CGRect(x:view.bounds.width * 13 / 15, y:view.bounds.height / 15, width:50 , height: 50)
        button.setImage(UIImage(named: "trash"), for: UIControl.State.normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.withAlphaComponent(0.7).cgColor
        button.tintColor = viewControllerTheme?.themeColor.primaryDarkColor
        button.addTarget(self, action: #selector(self.deleteButtonAction(_:)), for: .touchUpInside)
        
        self.view.addSubview(button)
    }
    
    func showAlert() {
        let alert = UIAlertController(
            title: "Eliminar ruta",
            message: "",
            preferredStyle: UIAlertController.Style.alert)
        let cancelButton = UIAlertAction(
            title:"Cancelar",
            style: UIAlertAction.Style.default,
            handler:
            {
                (alert: UIAlertAction!)  in
        })
        let okButton = UIAlertAction(title: "Eliminar ruta", style: UIAlertAction.Style.default) { (alert: UIAlertAction) in
            self.deleteRoute()
        }
        alert.addAction(cancelButton)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }

    
    
    @objc func deleteButtonAction(_ sender:UIButton!)
    {
        self.showAlert()
    }
    
    func deleteRoute() {
        DispatchQueue.main.async {
            let db = Firestore.firestore()
            
            db.collection("routes").document(self.route.id).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
                let storyboard = UIStoryboard(name: "DashboardStoryboard", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "Dashboard") as! MainViewController
                vc.getUserRouteData()
                self.present(vc, animated: true, completion: nil)
            }
        }
    }

    
    
        
        func animatePolyline() {
            currentIndex = 1
            
            // Start a timer that will simulate adding points to our polyline. This could also represent coordinates being added to our polyline from another source, such as a CLLocationManagerDelegate.
            timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
        }
        
        @objc func tick() {
            if currentIndex > allCoordinates.count {
                timer?.invalidate()
                timer = nil
                return
            }
            
            // Create a subarray of locations up to the current index.
            let coordinates = Array(allCoordinates[0..<currentIndex])
            
            // Update our MGLShapeSource with the current locations.
            updatePolylineWithCoordinates(coordinates: coordinates)
            
            currentIndex += 1
        }
        
        func updatePolylineWithCoordinates(coordinates: [CLLocationCoordinate2D]) {
            var mutableCoordinates = coordinates
            
            let polyline = MGLPolylineFeature(coordinates: &mutableCoordinates, count: UInt(mutableCoordinates.count))
            
            // Updating the MGLShapeSource’s shape will have the map redraw our polyline with the current coordinates.
            polylineSource?.shape = polyline
        }
    
}
