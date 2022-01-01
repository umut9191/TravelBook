//
//  ViewController.swift
//  TravelBook
//
//  Created by Mac on 1.01.2022.
//

import UIKit
import MapKit
//this lib for reaching out user location
import CoreLocation
class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{

    @IBOutlet weak var mapView: MKMapView!
    //this is from CoreLocation lib
    var locationManeger = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapView.delegate = self
        locationManeger.delegate = self
        //this is for accurancy for location if you chose best then phone batery will faster running out.
        locationManeger.desiredAccuracy = kCLLocationAccuracyBest
        //asking to user for location info
        locationManeger.requestWhenInUseAuthorization()
        //start taking user location;
        locationManeger.startUpdatingLocation()
    }
    //delegate method;
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //every pdating location of phone this method get datas in locations array
        
        var location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        //we took location now we will zoom on it
        //parameter how small zoom that much raise
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }


}

