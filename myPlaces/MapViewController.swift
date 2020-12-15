//
//  MapViewController.swift
//  
//
//  Created by Роман on 09.12.2020.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    var place = Place()
    var annotationIdentifier = "annotationIdentifier"
    var locationManager = CLLocationManager()
    let regionsInMetrs: Double = 10_000.00
    var incomeSegueIndentifier = ""
    
    
    
    @IBOutlet weak var mapPinImage: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setupMapView()
        checkLocationAutirization()

        // Do any additional setup after loading the view.
    }
    
  
    @IBAction func centerViewInUserLocation() {
        showUserLocation()
    }
    
    @IBAction func closeVC(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    private func setupMapView(){
        if incomeSegueIndentifier == "showPlace"{
            setupPlaceMark()
            mapPinImage.isHidden = true
        }
    }
    
    
    private func showUserLocation(){
        if let location = locationManager.location?.coordinate{
                    let region = MKCoordinateRegion(center: location,
                                                    latitudinalMeters: regionsInMetrs,
                                                    longitudinalMeters: regionsInMetrs)
                    mapView.setRegion(region, animated: true)
                }
    }
    
    
    
    // в этом методе мы извлекаем из location адрес и ищем его на карте
    private func setupPlaceMark(){
        guard let location = place.location else {return}
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            if let error = error{
                print(error)
                return
            }
            
            guard let placemarks = placemarks else{return}
            let placemark = placemarks.first
            
            let annotation = MKPointAnnotation()
            annotation.title = self.place.name
            annotation.subtitle = self.place.type
            
            guard let placemarkLocation = placemark?.location else {return}
            
            annotation.coordinate = placemarkLocation.coordinate
            self.mapView.showAnnotations([annotation], animated: true)
            self.mapView.selectAnnotation(annotation, animated: true)
        }
    }
    
    private func checkLOcationServices () {
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            checkLocationAutirization()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                self.alercController(tittle: "Location service is disable",
                                message: "To eneble it go: Setting -> Privacy -> Location services and turn ON")
            }
        }
    }
    
    private func setupLocationManager () {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // Вызов alert по влючению геолокации
    private func alercController(tittle: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let alertOk = UIAlertAction(title: "Ok", style: .default)
        
        alert.addAction(alertOk)
        present(alert, animated: true, completion: nil)
    }
    

    // проверка статуса на разрешение использования геолакации
    private func checkLocationAutirization () {
        let manager = CLLocationManager()
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            
            if incomeSegueIndentifier == "getAddress"{ showUserLocation()}
            
            break
        case .denied:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.alercController(
                    tittle: "Your Location is not Available",
                    message: "To give permission Go to: Setting -> MyPlaces -> Location"
                )
            }
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // надо дописать алертконтролдер
            break
        case.authorizedAlways:
            break
        @unknown default:
            fatalError()
        }
    }
    
}

extension MapViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {return nil}
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationIdentifier") as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.canShowCallout = true
            
        }
        
        if let imageData = place.imageData {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
            imageView.image = UIImage(data: imageData)
            annotationView?.rightCalloutAccessoryView = imageView
        }
        
        return annotationView
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAutirization()
    }
}


