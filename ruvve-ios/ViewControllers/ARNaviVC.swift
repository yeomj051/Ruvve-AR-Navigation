//
//  ARNaviVC.swift
//  RuvveNavigation
//
//  Created by Andrew Hart on 02/07/2017.
//  Copyright © 2017 Project Dent. All rights reserved.
//

import ARCL
import ARKit
import MapKit
import SceneKit
import UIKit

@available(iOS 11.0, *)
/// Displays Points of Interest in ARCL
// MARK: - StartVariable
class ARNaviVC: UIViewController {
    
    @IBAction func stopButton(_ sender: Any) {
        animateIn(desiredView: blurView)
        animateIn(desiredView: popupView)
    }
    
    @IBAction func goonButton(_ sender: Any) {
        animateOut(desiredView: popupView)
        animateOut(desiredView: blurView)
    }
    @IBAction func gostartButton(_ sender: Any) {
        if(self.storyboard?.instantiateViewController(withIdentifier: "DirectVC")as? DirectVC) != nil {
            self.navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func mapViewUserLocation(_ sender: Any) {
        centerMapOnUserLocation = true
    }
    
    @IBOutlet var popupView: UIView!
    @IBOutlet var blurView: UIVisualEffectView!
    
    @IBOutlet var stopTime: UILabel!
    @IBOutlet var moveDistance: UILabel!
    @IBOutlet var leaveDistance: UILabel!
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    var userToEnd: CLLocationDistance!
    var userToUser: CLLocationDistance!
    @IBOutlet var Alert: UILabel!
    
    @IBOutlet var contentView: UIView!
    let sceneLocationView = SceneLocationView()

    var userAnnotation: MKPointAnnotation?
    var locationEstimateAnnotation: MKPointAnnotation?

    var updateUserLocationTimer: Timer?
    var updateInfoLabelTimer: Timer?
    var nowState: Bool = true
    var Time: Int = 0
    
    //var destCoor: MKCoordinateRegion!

    var centerMapOnUserLocation: Bool = false
    var routes: [MKRoute]?
    
    var startPoint = CLLocationCoordinate2D()
    var endPoint = CLLocationCoordinate2D()

//    var startPlaceName: String = ""
//    var endPlaceName: String = ""
    
    var startLocation: MKMapItem!
    var destinationItem: MKMapItem!
    var startUserBool: Bool = true
    var startUserLocation: MKMapItem!

    var showMap = true

    let addNodeByTappingScreen = true
    
//
//    class func loadFromStoryboard() -> ARNaviVC {
//        return UIStoryboard(name: "Main", bundle: nil)
//            .instantiateViewController(withIdentifier: "ARCLViewController") as! ARNaviVC
//        // swiftlint:disable:previous force_cast
//    }
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startLocation = MKMapItem(placemark: MKPlacemark(coordinate: self.startPoint))
        
        self.navigationItem.setHidesBackButton(true, animated: true);
        
        destinationItem = MKMapItem(placemark: MKPlacemark(coordinate: self.endPoint))
        
        getDirections(to: destinationItem)
        
        //popup 정의
        blurView.bounds = self.view.bounds
        popupView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        
        // swiftlint:disable:next discarded_notification_center_observer
        NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification,
                                               object: nil,
                                               queue: nil) { [weak self] _ in
												self?.pauseAnimation()
        }
        // swiftlint:disable:next discarded_notification_center_observer
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification,
                                               object: nil,
                                               queue: nil) { [weak self] _ in
												self?.restartAnimation()
        }

		updateInfoLabelTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            if ((self?.nowState) == true) {
                self?.updateInfoLabel()
            } else {return}
			
		}

        sceneLocationView.arViewDelegate = self

        // Now add the route or location annotations as appropriate
        addSceneModels()

        contentView.addSubview(sceneLocationView)
        sceneLocationView.frame = contentView.bounds

        mapView.isHidden = !showMap
        
        setAnnotaion(with: self.startPoint)
        setAnnotaion(with: self.endPoint)
        
//        let appDel = UIApplication.shared.delegate as? AppDelegate
//        if appDel?.userInfoglobal != nil{
//            Alert.text = appDel?.userInfoglobal as? String
//        }

        UIView.animate(withDuration: 0.45,
                       delay: 0,
                       options: .allowUserInteraction,
                       animations: {
                        self.mapView.setCenter(self.startPoint, animated: false)
        }, completion: { _ in
            self.mapView.region.span = MKCoordinateSpan(latitudeDelta: 0.0005, longitudeDelta: 0.0005)
        })
        
        if showMap {
			updateUserLocationTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
				self?.updateUserLocation()
                self?.routes?.forEach { self?.mapView.addOverlay($0.polyline) }
			}
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print(#function)
        pauseAnimation()
        super.viewWillDisappear(animated)
    }

    func pauseAnimation() {
        print("pause")
        sceneLocationView.pause()
    }

    func restartAnimation() {
        print("run")
        sceneLocationView.run()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sceneLocationView.frame = contentView.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        restartAnimation()
    }

    // MARK: - JusticeFunc
    //popup Animate
    func animateIn(desiredView:UIView){
        let backgroundView = self.view!
        nowState = false
        
        backgroundView.addSubview(desiredView)
        
        desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        desiredView.alpha = 0
        desiredView.center = backgroundView.center
        
        stopTime.text = infoLabel.text
        leaveDistance.text = " \(self.userToEnd ?? 0.0)M"
//        moveDistance.text = " \(getDistance(to: self.startUserLocation, to: MKMapItem.forCurrentLocation(), to: true))M"
        
        UIView.animate(withDuration: 0.3, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            desiredView.alpha = 1
        })
    }
    
    func animateOut(desiredView:UIView){
        nowState = true
        UIView.animate(withDuration: 0.3, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            desiredView.alpha = 0
        }, completion: { _ in
            desiredView.removeFromSuperview()
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first,
            let view = touch.view else { return }

        if mapView == view || mapView.recursiveSubviews().contains(view) {
            centerMapOnUserLocation = false
        } else {
            if addNodeByTappingScreen {
                let image = UIImage(named: "pin")!
                let annotationNode = LocationAnnotationNode(location: nil, image: image)
                annotationNode.scaleRelativeToDistance = false
                annotationNode.scalingScheme = .normal
                DispatchQueue.main.async {
                    // If we're using the touch delegate, adding a new node in the touch handler sometimes causes a freeze.
                    // So defer to next pass.
                    self.sceneLocationView.addLocationNodeForCurrentPosition(locationNode: annotationNode)
                }
            }
        }
    }
}

// MARK: - MKMapViewDelegate
@available(iOS 11.0, *)
extension ARNaviVC: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.lineWidth = 3
        renderer.strokeColor = UIColor.purple.withAlphaComponent(0.8)

        return renderer
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation),
           let pointAnnotation = annotation as? MKPointAnnotation else { return nil }

        let marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)

        if pointAnnotation == self.userAnnotation {
            marker.displayPriority = .required
            marker.glyphImage = UIImage(named: "user")
        } else {
            marker.displayPriority = .required
            marker.markerTintColor = UIColor(hue: 0.267, saturation: 0.67, brightness: 0.77, alpha: 1.0)
            marker.glyphImage = UIImage(named: "compass")
        }

        return marker
    }
}

// MARK: - Implementation
@available(iOS 11.0, *)
extension ARNaviVC {

    /// Adds the appropriate ARKit models to the scene.  Note: that this won't
    /// do anything until the scene has a `currentLocation`.  It "polls" on that
    /// and when a location is finally discovered, the models are added.
    func addSceneModels() {
        // 1. Don't try to add the models to the scene until we have a current location
        guard sceneLocationView.sceneLocationManager.currentLocation != nil else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.addSceneModels()
            }
            return
        }

        let box = SCNBox(width: 1, height: 0.2, length: 5, chamferRadius: 0.25)
        box.firstMaterial?.diffuse.contents = UIColor.gray.withAlphaComponent(0.8)

        // 2. If there is a route, show that
        if let routes = routes {
            
            sceneLocationView.addRoutes(routes: routes) { distance -> SCNBox in
                let box = SCNBox(width: 1.75, height: 0.5, length: distance, chamferRadius: 0.25)

//                // Option 1: An absolutely terrible box material set (that demonstrates what you can do):
//                box.materials = ["box0", "box1", "box2", "box3", "box4", "box5"].map {
//                    let material = SCNMaterial()
//                    material.diffuse.contents = UIImage(named: $0)
//                    return material
//                }

                // Option 2: Something more typical
                box.firstMaterial?.diffuse.contents = UIColor.purple.withAlphaComponent(0.8)
                return box
            }
        }

        // There are many different ways to add lighting to a scene, but even this mechanism (the absolute simplest)
        // keeps 3D objects fron looking flat
        sceneLocationView.autoenablesDefaultLighting = true

    }
    // MARK: - UserUpdate
    @objc
    func updateUserLocation() {
        guard let currentLocation = sceneLocationView.sceneLocationManager.currentLocation else {
            return
        }

        DispatchQueue.main.async { [weak self ] in
            guard let self = self else {
                return
            }

            if self.userAnnotation == nil {
                self.userAnnotation = MKPointAnnotation()
                self.mapView.addAnnotation(self.userAnnotation!)
            }
            if self.startUserBool{
                self.startUserLocation = MKMapItem(placemark: MKPlacemark(coordinate: currentLocation.coordinate))
                self.startUserBool = false
            }
            

            UIView.animate(withDuration: 0.5, delay: 0, options: .allowUserInteraction, animations: {
                self.userAnnotation?.coordinate = currentLocation.coordinate
            }, completion: nil)

            if self.centerMapOnUserLocation {
                UIView.animate(withDuration: 0.45,
                               delay: 0,
                               options: .allowUserInteraction,
                               animations: {
                                self.mapView.setCenter(self.userAnnotation!.coordinate, animated: false)
                }, completion: { _ in
                    self.mapView.region.span = MKCoordinateSpan(latitudeDelta: 0.0005, longitudeDelta: 0.0005)
                })
            }
        }
    }

    @objc
    func updateInfoLabel() {
        Time += 1
        
        let second = Time % 60
        let minute = (Time % 3600) / 60
        let hour = Time / 3600

        infoLabel.text = " \(hour.short):\(minute.short):\(second.short)" + "\""
        distanceLabel.text = " \(getDistance(to: MKMapItem.forCurrentLocation(), to: self.destinationItem, to: false))M"
        moveDistance.text = " \(getDistance(to: self.startUserLocation, to: MKMapItem.forCurrentLocation(), to: true))M"
    }
}

// MARK: - GetDirections
@available(iOS 11.0, *)
extension ARNaviVC {
    
    func getDirections(to mapLocation: MKMapItem) {

        let request = MKDirections.Request()
        request.source = startLocation
        request.destination = mapLocation
        request.requestsAlternateRoutes = false

        let directions = MKDirections(request: request)

        directions.calculate(completionHandler: { response, error in
            if let error = error {
                return print("Error getting directions: \(error.localizedDescription)")
            }
            guard let response = response else {
                return assertionFailure("No error, but no response, either.")
            }

            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                self.routes = response.routes
            }
        })
    }
    
    func getDistance(to StartLocation: MKMapItem, to EndLocation: MKMapItem, to userToUser: Bool) -> CLLocationDistance{
        
        var distanceIn: CLLocationDistance = 0.0
        print(EndLocation)
        print("9876543456700000000000000000000000")
        let request = MKDirections.Request()
        request.source = StartLocation
        request.destination = EndLocation
        request.requestsAlternateRoutes = false

        let directions = MKDirections(request: request)

        directions.calculate(completionHandler: { response, error in
            if let error = error {
                return print("Error getting directions: \(error.localizedDescription)")
            }
            guard let response = response else {
                return assertionFailure("No error, but no response, either.")
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                if userToUser{
                    self.userToUser = (response.routes.first?.distance)!
                }else{
                    self.userToEnd = (response.routes.first?.distance)!
                }
            }
        })
        if userToUser{
            distanceIn = self.userToUser ?? 0.0
        }else{
            distanceIn = self.userToEnd ?? 0.0
        }
        return distanceIn
    }
    
    func setAnnotaion(with coordinates: CLLocationCoordinate2D){
        // Add a map pin
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        
        mapView.addAnnotation(pin)
        mapView.setRegion(MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: true)
    }

}
// MARK: - Helpers

extension DispatchQueue {
    func asyncAfter(timeInterval: TimeInterval, execute: @escaping () -> Void) {
        self.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(timeInterval * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
            execute: execute)
    }
}

extension UIView {
    func recursiveSubviews() -> [UIView] {
        var recursiveSubviews = self.subviews

        subviews.forEach { recursiveSubviews.append(contentsOf: $0.recursiveSubviews()) }

        return recursiveSubviews
    }
}
