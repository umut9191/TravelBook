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
import CoreData
class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    @IBOutlet weak var txtComment: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    var chosenPlace:PlacesModel?
    var chosenlatitude=Double()
    var chosenLongtitude=Double()
    //this is from CoreLocation lib
    var locationManeger = CLLocationManager()
//    var annotationLatitude=Double()
//    var annotationLongtitude=Double()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let data = chosenPlace {
            txtName.text = data.title
            txtComment.text = data.subtitle
            //create new annotation for map;
            let annotation = MKPointAnnotation()
            annotation.title = data.title
            annotation.subtitle = data.subtitle
            let coordinate = CLLocationCoordinate2D(latitude: data.latitude, longitude: data.longtitude)
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            //for stoping updatin location changed
            locationManeger.stopUpdatingLocation()
            var span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            mapView.setRegion(region, animated: true)
//            annotationLatitude = data.latitude
//            annotationLongtitude = data.longtitude
            
        
        }
        mapView.delegate = self
        locationManeger.delegate = self
        //this is for accurancy for location if you chose best then phone batery will faster running out.
        locationManeger.desiredAccuracy = kCLLocationAccuracyBest
        //asking to user for location info
        locationManeger.requestWhenInUseAuthorization()
        //start taking user location;
        locationManeger.startUpdatingLocation()
        //gesture recognizer on long press
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(pinLocation(gestureRecognizer:)))
        //pression how seconds long
        gestureRecognizer.minimumPressDuration = 3
        mapView.addGestureRecognizer(gestureRecognizer)
        
        
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        //core data save codes will be here
        var appDelegate = UIApplication.shared.delegate as! AppDelegate
        var context = appDelegate.persistentContainer.viewContext
        let newPlace = NSEntityDescription.insertNewObject(forEntityName: "Places", into: context)
        newPlace.setValue(txtName.text, forKey: "title")
        newPlace.setValue(txtComment.text, forKey: "subtitle")
        newPlace.setValue(chosenlatitude, forKey: "latitude")
        newPlace.setValue(chosenLongtitude, forKey: "longtitude")
        newPlace.setValue(UUID(), forKey: "id")
        
        do {
            try context.save()
            print("successfully data inserted")
        } catch  {
            print("error when saving place \(error)")
        }
        
        
        
        
    }
    @objc func pinLocation(gestureRecognizer:UILongPressGestureRecognizer){
        
        if gestureRecognizer.state == .began {
           // touched poing on mapView;
            let touchPoint = gestureRecognizer.location(in: self.mapView)
            //convert touch point to location points coordinates;
            let touchedCoordinates = self.mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
            chosenlatitude = touchedCoordinates.latitude
            chosenLongtitude = touchedCoordinates.longitude
            //creating pin
            let annotation = MKPointAnnotation()
            annotation.coordinate = touchedCoordinates
            annotation.title = txtName.text
            annotation.subtitle = txtComment.text
            self.mapView.addAnnotation(annotation)
            
        }
        
    }
    //delegate method;
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //every pdating location of phone this method get datas in locations array
        if chosenPlace == nil {
            let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
            //we took location now we will zoom on it
            //parameter how small zoom that much raise
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            
            let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)
        }
       
    }


}

