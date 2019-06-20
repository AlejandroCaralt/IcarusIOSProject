import Mapbox
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections
import FirebaseFirestore
import Firebase

class CreateRouteViewController: UIViewController, MGLMapViewDelegate {
    var mapView: NavigationMapView!
    var directionsRoute: Route?
    var centerCoordinate = CLLocationCoordinate2D(latitude: 36.7225193, longitude: -4.4240461)
    var userInfo: FirebaseUser!
    var viewControllerTheme : Theme? = MBXTheme.grayTheme
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = NavigationMapView(frame: view.bounds)
        
        view.addSubview(mapView)
        
        // Set the map view's delegate
        mapView.delegate = self
        mapView.styleURL = URL(string: "mapbox://styles/forgusdie/cjw9b7erw0cbp1cnubfgs4h0f")
        
        // Allow the map to display the user's location
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        addBackButton()
        
        // Add a gesture recognizer to the map view
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        mapView.addGestureRecognizer(longPress)
        if CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .notDetermined {
            mapView.setCenter(centerCoordinate, zoomLevel: 11, animated: false)
        }
    }
    
    @objc func didLongPress(_ sender: UILongPressGestureRecognizer) {
        guard sender.state == .began else { return }
        
        // Converts point where user did a long press to map coordinates
        let point = sender.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        
        // Create a basic point annotation and add it to the map
        let annotation = MGLPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Start navigation"
        mapView.addAnnotation(annotation)
        
        // Calculate the route from the user's location to the set destination
        calculateRoute(from: (mapView.userLocation!.coordinate), to: annotation.coordinate) { (route, error) in
            if error != nil {
                print("Error calculating route")
            }
        }
    }
    
    // Calculate route to be used for navigation
    func calculateRoute(from origin: CLLocationCoordinate2D,
                        to destination: CLLocationCoordinate2D,
                        completion: @escaping (Route?, Error?) -> ()) {
        
        // Coordinate accuracy is the maximum distance away from the waypoint that the route may still be considered viable, measured in meters. Negative values indicate that a indefinite number of meters away from the route and still be considered viable.
        let origin = Waypoint(coordinate: origin, coordinateAccuracy: -1, name: "Start")
        let destination = Waypoint(coordinate: destination, coordinateAccuracy: -1, name: "Finish")
        
        // Specify that the route is intended for automobiles avoiding traffic
        let options = NavigationRouteOptions(waypoints: [origin, destination], profileIdentifier: .cycling)
        
        // Generate the route object and draw it on the map
        _ = Directions.shared.calculate(options) { [unowned self] (waypoints, routes, error) in
            self.directionsRoute = routes?.first
            // Draw the route on the map after creating it
            self.drawRoute(route: self.directionsRoute!)
        }
    }
    
    func drawRoute(route: Route) {
        guard route.coordinateCount > 0 else { return }
        // Convert the route’s coordinates into a polyline
        var routeCoordinates = route.coordinates!
        let polyline = MGLPolylineFeature(coordinates: &routeCoordinates, count: route.coordinateCount)
        
        // If there's already a route line on the map, reset its shape to the new route
        if let source = mapView.style?.source(withIdentifier: "route-source") as? MGLShapeSource {
            source.shape = polyline
        } else {
            let source = MGLShapeSource(identifier: "route-source", features: [polyline], options: nil)
            
            // Customize the route line color and width
            let lineStyle = MGLLineStyleLayer(identifier: "route-style", source: source)
            lineStyle.lineColor = NSExpression(forConstantValue: #colorLiteral(red: 0.1897518039, green: 0.3010634184, blue: 0.7994888425, alpha: 1))
            lineStyle.lineWidth = NSExpression(forConstantValue: 3)
            
            // Add the source and style layer of the route line to the map
            mapView.style?.addSource(source)
            mapView.style?.addLayer(lineStyle)
        }
    }
    
    func uploadRoute(route: Route) {
        DispatchQueue.main.async {
            let db = Firestore.firestore()
            //Update the user data
            
            var coordenates: [GeoPoint] = []
            for n in route.legs {
                for i in n.steps {
                    for x in i.intersections! {
                        coordenates.append(GeoPoint(latitude: x.location.latitude, longitude: x.location.longitude))
                    }
                }
            }
            var km = route.distance / 1000
            var time = route.expectedTravelTime / 60
            let userId = Auth.auth().currentUser?.uid
            let name = route.legs[0].steps[0].names![0]
            
            let ref1 = db.collection("routes").document()
            
            ref1.setData([
                "routesCoordinates" : coordenates,
                "km" : km,
                "owner" : userId,
                "highestPoint" : 20,
                "lowestPoint" : 19,
                "time" : time,
                "typeRoute" : "field",
                "name" : name
                ])
            
            let nameUser = self.userInfo.name
            let hoursUser = self.userInfo.hours + time
            let kmUser = self.userInfo.km + km
            let cityUser = self.userInfo.city
            let routesDoneUser = self.userInfo.routesDone + 1
            let sentenceUser = self.userInfo.sentence
            
            let ref2 = db.collection("users").document(userId!).updateData([
                "name" : nameUser,
                "hours" : hoursUser,
                "km" : kmUser,
                "city": cityUser,
                "routesDone" : routesDoneUser,
                "sentence" : sentenceUser
                ])
            
            let storyboard = UIStoryboard(name: "DashboardStoryboard", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Dashboard") as! MainViewController
            
            vc.getData()
        }
    }
    
    // Implement the delegate method that allows annotations to show callouts when tapped
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    // Present the navigation view controller when the callout is selected
    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        let navigationViewController = NavigationViewController(for: directionsRoute!)
        self.uploadRoute(route: self.directionsRoute!)
        self.present(navigationViewController, animated: true, completion: nil)
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
}

