//
//  ViewController.swift
//  CoreLocationMapKit
//
//  Created by etudiant on 27/09/17.
//  Copyright © 2017 etudiant. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import RealmSwift

class MapViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {
    
    //realm notification
    var notificationToken: NotificationToken?
    var notificationConnectToken : NotificationToken?
    
    var locationManager:CLLocationManager!
    var selectedBI: BienImmobilierDetailsImages?
    let regionRadius: CLLocationDistance = 1000
    var lastLocation : CLLocation?
    var currentLocation: CLLocation?
    //let locationManager = CLLocationManager()
    
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var segmentedView: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // set initial location in Honolulu
        // let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        
        // centerMapOnLocation(location: initialLocation)
        
        
//        self.locationManager.delegate = self
//        
//        self.locationManager.requestWhenInUseAuthorization()
//        self.locationManager.startUpdatingLocation()
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        self.addPins()
        
        self.activityIndicator.hidesWhenStopped = true
        self.progressView.setProgress(0, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        determineCurrentLocation()
        mapView.zoomMapaFitAnnotations()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        notificationToken?.stop()
        
        notificationConnectToken?.stop()
    }
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
                if let currentLocation = locations.first{
            
            self.currentLocation = currentLocation
            print(currentLocation.coordinate)
            print(currentLocation.timestamp)
            print(currentLocation.horizontalAccuracy)
            
        
    
        //si deplacement > 50 m refresh de la map
        if let lastlocation = lastLocation {
            
            //si deplacement > 25 metres refresh de la map
            if lastlocation.distance(from: self.currentLocation!)>25{
                print("DEPLACEMENT")
                
                 mapView.layoutMargins = UIEdgeInsets(top: 40, left: 25, bottom: 25, right: 25)
                mapView.showAnnotations(mapView.annotations, animated: true)
                centerMapOnLocation(location: currentLocation)
                mapView.zoomMapaFitAnnotations()
                lastLocation = currentLocation
            }
            
           
        }
        else {
            
            lastLocation = currentLocation
                mapView.zoomMapaFitAnnotations()
        }
        
        }
    }
    
    func addPins() {
       // self.activityIndicator.startAnimating()
   //     let session = SyncUser.current?.session(for: Constants.syncServerURL!)!
        let realm = try! Realm()
        //activity
         notificationConnectToken = realm.addNotificationBlock { [unowned self] note, realm in
            //let realm = try! Realm()
            
            let bimspics: Results<BienImmobilierDetailsImages> = { realm.objects(BienImmobilierDetailsImages.self) }()
            
            for bi in bimspics{
                
                print("BIM2",bi.nom,bi.longitude, bi.latitude)
                let location = CLLocationCoordinate2D(latitude: bi.latitude, longitude: bi.longitude)
                self.addImmoPin(title: bi.nom, location: location,bienimmo: bi)
            }
            
            
            //CENTRAGE sur les PINANNOTATIONS
           // self.mapView.showAnnotations(self.mapView.annotations, animated: true)
            self.mapView.zoomMapaFitAnnotations()
           // self.activityIndicator.stopAnimating()
            self.progressView.isHidden = true
        }
        //notificationTokenconnect.stop()
        
        
//        notificationToken = session?.addProgressNotification(for: .download,
//                                                    mode: .reportIndefinitely) { progress in
//                                                        if progress.isTransferComplete {
//                                                            self.activityIndicator.stopAnimating()
//                                                        } else {
//                                                            self.activityIndicator.startAnimating()
//                                                        }
//        }

  
        
        
//    self.notificationToken = session?.addProgressNotification(for: .download ,
//                                                 mode: .forCurrentlyOutstandingWork) { progress in
//                                                   // self.progressView.setProgress(Float(progress.fractionTransferred), animated: true)
//                                                    //DATA CODE
//                                                    
//                                                    let realm = try! Realm()
//                                                    
//                                                    let bimspics: Results<BienImmobilierDetailsImages> = { realm.objects(BienImmobilierDetailsImages.self) }()
//                                                    
//                                                    for bi in bimspics{
//                                                       
//                                                        print("BIM2",bi.nom,bi.longitude, bi.latitude)
//                                                        let location = CLLocationCoordinate2D(latitude: bi.latitude, longitude: bi.longitude)
//                                                        self.addImmoPin(title: bi.nom, location: location,bienimmo: bi)
//                                                    }
//                                                    
//                                                    //END DATACODE
//                                                    
//                                                    
//                                                    if progress.isTransferComplete {
//                                                        //self.hideProgressBar()
//                                                        self.activityIndicator.stopAnimating()
//                                                        //self.notificationToken?.stop()
//                                                        self.progressView.isHidden = true
//                                                    }
//    }
//    
//
        
        
        
        //end activity
        
        
        
        
        
        //retrienve pins from REalm
        //let realm = try! Realm()
               
        let bimspics: Results<BienImmobilierDetailsImages> = { realm.objects(BienImmobilierDetailsImages.self) }()
        
        for bi in bimspics{
            
            print("BIM2",bi.nom,bi.longitude, bi.latitude)
            let location = CLLocationCoordinate2D(latitude: bi.latitude, longitude: bi.longitude)
            addImmoPin(title: bi.nom, location: location,bienimmo: bi)
        }
        
        
        //CENTRAGE sur les PINANNOTATIONS
       // mapView.showAnnotations(mapView.annotations, animated: true)
        mapView.zoomMapaFitAnnotations()

        activityIndicator.stopAnimating()
        progressView.isHidden = true

    }
    //add general info pin
    func addPin(title titlepin: String,location locationpin: CLLocationCoordinate2D){
        
        let pin = MKPointAnnotation()
        pin.coordinate = locationpin
        pin.title = titlepin
        mapView.addAnnotation(pin)
        
    }
    //add Immo special pin
    
    func addImmoPin(title titlepin: String,location locationpin: CLLocationCoordinate2D,bienimmo bienimmopin: BienImmobilierDetailsImages){
       
        DispatchQueue.main.async {
            let pin = MKBienImmoPointAnnotation()
            pin.coordinate = locationpin
            pin.title = titlepin
            pin.immoData = bienimmopin
            pin.imageName = "icons8-MapPin-64"
            self.mapView.addAnnotation(pin)
             self.mapView.showAnnotations(self.mapView.annotations, animated: true)
            self.mapView.zoomMapaFitAnnotations()
        }
        
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKBienImmoPointAnnotation{
            let pinId = "myPinIdentifierforBI"
            var pinView: MKAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: pinId) as? MKBienImmoAnnotationView  {
                dequeuedView.annotation = annotation
                pinView = dequeuedView
                
            }else{
                
                pinView = MKBienImmoAnnotationView(annotation: annotation, reuseIdentifier: pinId)
                
                //pinView.pinColor = .purple
                let newannotation = annotation as! MKBienImmoPointAnnotation
              //  pinView.image = UIImage(named: newannotation.imageName)
              //  pinView.set
                //pinView.isDraggable = true
                pinView.canShowCallout = true
              //  pinView.animatesDrop = true
                
                let goButton = UIButton(type: UIButtonType.custom) as UIButton
                goButton.frame.size.width = 44
                goButton.frame.size.height = 44
                goButton.backgroundColor = UIColor.purple
                goButton.setImage(UIImage(named: "check-sign(1)"), for: [.normal])
                
                pinView.leftCalloutAccessoryView = goButton
                
                
                
            }
          //  pinView.image = UIImage(named: "star")
            return pinView
            
        }
        else {
            
            
            if annotation is MKUserLocation{
                
                let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPinIdentifierlocuser")
                return pinView
            }else{
                let pinId = "myPinIdentifier"
                var pinView: MKPinAnnotationView
                if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: pinId) as? MKPinAnnotationView {
                    dequeuedView.annotation = annotation
                    pinView = dequeuedView
                    
                    //                //***
                    //                pinView.pinColor = .purple
                    //                //pinView.isDraggable = true
                    //                pinView.canShowCallout = true
                    //                pinView.animatesDrop = true
                    //
                    //                let goButton = UIButton(type: UIButtonType.custom) as UIButton
                    //                goButton.frame.size.width = 44
                    //                goButton.frame.size.height = 44
                    //                goButton.backgroundColor = UIColor.purple
                    //                goButton.setImage(UIImage(named: "trash"), for: [.normal])
                    //
                    //                pinView.leftCalloutAccessoryView = goButton
                    
                    
                    
                    //***
                    
                    
                    
                }else{
                    pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinId)
                    
                    pinView.pinColor = .purple
                    //pinView.isDraggable = true
                    pinView.canShowCallout = true
                    pinView.animatesDrop = true
                    
                    let goButton = UIButton(type: UIButtonType.custom) as UIButton
                    goButton.frame.size.width = 44
                    goButton.frame.size.height = 44
                    goButton.backgroundColor = UIColor.purple
                    goButton.setImage(UIImage(named: "check-sign(1)"), for: [.normal])
                    
                    pinView.leftCalloutAccessoryView = goButton
                    
                }
                return pinView
            }
            
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        
        guard let annotation = view.annotation else
        {
            return
        }
         view.canShowCallout = true
       print("PIN SELECTED1",annotation.title!! as String as Any  )
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        
        guard let annotation = view.annotation else
        {
            return
        }
        print("PIN SELECTED2",annotation.title as? String as Any  )
        //perform segue
        if let myMKBIAnnotation = view.annotation as? MKBienImmoPointAnnotation{
            selectedBI = myMKBIAnnotation.immoData
            self.performSegue(withIdentifier: "SegueMapToDetailBI", sender: self)
        
        }
    }
        
        
        


    
    func mapView( mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView)
    {
        if let annotationTitle = view.annotation?.title
        {
            print("User tapped on annotation with title: \(annotationTitle!)")
        }
  }
    func determineCurrentLocation()
    {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if locationManager.allowsBackgroundLocationUpdates{
            
            locationManager.allowDeferredLocationUpdates(untilTraveled: CLLocationDistance(60), timeout: TimeInterval(60))
        
        }
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            //locationManager.startUpdatingHeading()
            locationManager.pausesLocationUpdatesAutomatically = true
            locationManager.startUpdatingLocation()
        }
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        manager.stopUpdatingLocation()
        
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
      //  mapView.setRegion(region, animated: true)
        
        // Drop a pin at user's Current Location
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
        myAnnotation.title = "Current location"
        mapView.addAnnotation(myAnnotation)
        mapView.zoomMapaFitAnnotations()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Error  location manager \(error)")
    }
    
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "SegueMapToDetailBI" {
        let destinationViewController = segue.destination as! DetailBienImmoWithPicsViewController
        destinationViewController.bienImmo = self.selectedBI
        
    }

}
    
        @IBAction func indexChanged(_ sender: UISegmentedControl) {
            
            
             mapView.mapType = MKMapType.init(rawValue: UInt(sender.selectedSegmentIndex)) ?? .standard
          
                      
            
    }

}
