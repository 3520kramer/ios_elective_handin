//
//  ViewController.swift
//  Maps
//
//  Created by Oliver Kramer on 27/03/2020.
//  Copyright © 2020 Oliver Kramer. All rights reserved.
//

import UIKit
import MapKit
import FirebaseFirestore
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet var longPressRecognizer: UILongPressGestureRecognizer!
    
    private let locationManager = CLLocationManager() // core location manager used to query for gps data
    private let regionInMeters: Double = 10000 // how much we wan't the map to be zoomed in
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        
        map.delegate = self
        
        map.addGestureRecognizer(longPressRecognizer)
        
        checkLocationService()
        
        FirebaseRepo.startListener(vc:self)

    }

    // Here we added a longpress gesture recognizer in the storyboard and connected it as an action
    @IBAction func longPressed(_ sender: UILongPressGestureRecognizer) {
        
        if sender.state == .ended { // Makes sure that this code will be executed when the long press has ended
            
            // Core Graphics Point is a point in a coordinate system which represents the screen
            let cgPoint = sender.location(in: map)
            let coordinates = map.convert(cgPoint, toCoordinateFrom: map)
            let marker = MKPointAnnotation()

            
            getAddressFromCoordinates(coordinates: coordinates){ (address) in
                marker.title = "My new location"
                marker.subtitle = address
                marker.coordinate = coordinates
                
                self.map.addAnnotation(marker) // Adds a marker to the map to give a good user experience. It's removed and the real one is added from firebase when the user dismisses the view of the popup
                self.showPopUp(annotation: marker)
            }
            
        }
    }
    
    func getAddressFromCoordinates(coordinates: CLLocationCoordinate2D, completion: @escaping (String) -> ()){
        let geoCoder = CLGeocoder() // GeoCoder is able to convert coordinates to a user friendly representation
        let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude) // The GeoCoder requires a CLLocation two get the coordinates
        
        // The [weak self] is a way of avoiding the retain cycle
        // the retain cycle is a problem where objects don't get deallocated in the memory
        // closures hold a strong connection to the object, so by passing self as weak, we make it optional
        geoCoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            
            // to avoid us getting an optional we unwrap self here
            // it's guarded so if it's nil, it will return nothing (which is the same as exiting this function)
            guard let self = self else { return }
            
            // if there is an error we wan't to alert the user
            // the underscore is a way of saying that we are not interested in giving the constant a name
            if let _ = error{
                // alert user
                return
            }
            
            // check if placemarks isn't empty and saves the first element of the list of placemarks in a constant called placemark
            // placemarks contains the user friendly information such as address etc.
            guard let placemark = placemarks?.first else{
                // alert user
                return
            }
            
            let streetName = placemark.thoroughfare ?? ""
            let streetNumber = placemark.subThoroughfare ?? ""
            let city = placemark.locality ?? ""
            let postalcode = placemark.postalCode ?? ""
            let country = placemark.country ?? ""
            
            let fullAddress = "\(streetName) \(streetNumber), \(postalcode) \(city), \(country)"
            
            print("\(streetName) \(streetNumber), \(postalcode) \(city), \(country)")

            
            DispatchQueue.main.async {
                completion(fullAddress)
            }
            
        }
        
    }
    
    // function that sets up the location manager
    func setUpLocationManager(){
        locationManager.delegate = self // sets the delegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // sets the desired accuracy to the best possible accuracy
        
    }
    
    // function that checks if the location services of the device isn't turned off
    func checkLocationService(){
        if CLLocationManager.locationServicesEnabled(){
            setUpLocationManager()
            checkLocationAuthorization()
        }else{
            // create an alert that tells the user to turn on location services
        }
    }
    
    func centerViewOnUserLocation(){
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            map.setRegion(region, animated: true)
        }
    }
    
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            print("when in use")
            map.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation() // if the user moves, the locationmanager will update the location. Calls the didUpdateLocation method in the extension
            break
            
        case .denied:
            // show an alert to make the user know that it's device hasn't given permission
            break
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization() // requests the type of authorization that we want
            break
            
        case .restricted:
            print("restricted")

            break
            
        case .authorizedAlways:
            break
            
        
        @unknown default:
            print("my default")
            break
        }
    }
    
    
    
    func updateMarkersOnMap(snap: QuerySnapshot){
        let annotations = MapDataAdapter.getMKAnnotationsFromData(snap: snap)
        map.removeAnnotations(map.annotations)
        map.addAnnotations(annotations)
        
    }
    
    func showPopUp(annotation: MKPointAnnotation){
        // Creates a new viewcontroller which slides up from the bottom, when hitting the details button on an annotation
        let popUpViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "popUp") as PopUpViewController
        
        // A 'UIView' was created on the new view controller in the storyboard, and moved to the bottom of the view controller
        // The background of the pop up view controllers opacity is set to 0 and the presentation style is set to 'over current context' to make sure it's on top of the old view
        // This makes the rest of the view controller 'invisible' aka. when the 'UIView' pops up, the rest of the view controller isn't visible
        popUpViewController.modalPresentationStyle = .overCurrentContext

        // Saves the information from the marker on the map, in the pop up view controller, so when it's presented, it can be used right away
        popUpViewController.annotation = annotation

        
        // The new view is presented on top of the old view controller
        present(popUpViewController, animated: true, completion: {
            // When tapping outside of the view, the pop up will be dismissed
            popUpViewController.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
        })
    }
    
    @objc func dismissOnTapOutside(){
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension ViewController: MKMapViewDelegate{
    // function that styles each annotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // We use a guard statement to check if the annotation is a user location
        // if the annotation is a user location it shall return nil, or else proceed
        guard !(annotation is MKUserLocation) else { return nil }
        
        // sets the identifier
        let identifier = "annotation"
        
        // Makes sure that we reuse an annotation if it's not in the current view
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        // if there isn't already created annotation available we create a new one
        if annotationView == nil{
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .close) // Delete button for annotation
        // if there is one available we reuse it and fills it with data
        }else{
            annotationView?.annotation = annotation
        }
        
        // returns the styles annotation
        return annotationView
        
    }
    
    
    // This function is called when you press the button on an annotation
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        // Deletes the annotation from firebase
        FirebaseRepo.deleteAnnotation(marker: view.annotation as! MKPointAnnotation)
        
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    // every time the user moves, this function is fired off
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        map.setRegion(region, animated: true)
    }
    
    // if the authorization changes, then we need to call our checkAuthorization function from above
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}
