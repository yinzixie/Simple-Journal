//
//  MapScreen.swift
//  SimpleJournal
//
//  Created by yinzixie on 29/4/19.
//  Copyright © 2019 UTAS. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol PassLocationData {
    func passLocationString(location:String)
}

class MapScreen: UIViewController, UISearchBarDelegate  {

    var passLocationData: PassLocationData?
    
    let LocationManager = CLLocationManager()
    let RegionInMeters = 10000
    var PreviousLocation: CLLocation?
    
    var Location:String = ""
    
    @IBOutlet var SearchBar: UISearchBar!
    @IBOutlet var MapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        checkLocationServices()
        initLocation()
    }
    
    func initLocation() {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(getCenterLocation(for: MapView)) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if let _ = error {
                //TODO: Show alert informing the user
                return
            }
            
            guard let placemark = placemarks?.first else {
                //TODO: Show alert informing the user
                return
            }
            
            let Country = placemark.country ?? ""
            let City = placemark.locality ?? ""
            
            let StreetNumber = placemark.subThoroughfare ?? ""
            let StreetName = placemark.thoroughfare ?? ""
            
            DispatchQueue.main.async {
                self.SearchBar.text = "\(Country) \(City) \(StreetNumber) \(StreetName)"
                self.Location = "\(Country) \(City) \(StreetNumber) \(StreetName)"
            }
        }
    }
    
    func setupLocationManager() {
        LocationManager.delegate = self
        LocationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation() {
        if let location = LocationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: CLLocationDistance(RegionInMeters), longitudinalMeters: CLLocationDistance(RegionInMeters))
            MapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            MapView.showsUserLocation = true
            centerViewOnUserLocation()
            LocationManager.startUpdatingLocation()
            PreviousLocation = getCenterLocation(for: MapView)
            break
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            LocationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        }
    }
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = MapView.centerCoordinate.latitude
        let longitude = MapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        //Ignoring user
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        //Activity Indicator
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
     
        //Create the search request
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { (response, error) in
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if response == nil
            {
                print("ERROR")
            }
            else
            {
                //Remove annotations
                let annotations = self.MapView.annotations
                self.MapView.removeAnnotations(annotations)
                
                //Getting data
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                //Create annotation
                let annotation = MKPointAnnotation()
                annotation.title = searchBar.text
                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                self.MapView.addAnnotation(annotation)
                
                //Zooming in on annotation
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                let region = MKCoordinateRegion(center: coordinate, span: span)
                self.MapView.setRegion(region, animated: true)
            }
            
        }
    }
    @IBAction func cancleButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func chooseButton(_ sender: Any) {
        self.Location = self.SearchBar.text ?? ""
        print(Location)
        passLocationData?.passLocationString(location:Location)
        self.dismiss(animated: true, completion: nil)
    }
}


extension MapScreen: CLLocationManagerDelegate {
    
  /*  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: CLLocationDistance(RegionInMeters), longitudinalMeters: CLLocationDistance(RegionInMeters))
        MapView.setRegion(region, animated: true)
    }*/
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension MapScreen: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        let geoCoder = CLGeocoder()
        
        guard let PreviousLocation = self.PreviousLocation else { return }
        
        guard center.distance(from: PreviousLocation) > 50 else { return }
        self.PreviousLocation = center
        
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if let _ = error {
                //TODO: Show alert informing the user
                return
            }
            
            guard let placemark = placemarks?.first else {
                //TODO: Show alert informing the user
                return
            }
            
            let Country = placemark.country ?? ""
            let City = placemark.locality ?? ""
            
            let StreetNumber = placemark.subThoroughfare ?? ""
            let StreetName = placemark.thoroughfare ?? ""
            
            DispatchQueue.main.async {
                self.SearchBar.text = "\(Country) \(City) \(StreetNumber) \(StreetName)"
                self.Location = "\(Country) \(City) \(StreetNumber) \(StreetName)"
            }
            
            
        }
    }
}
