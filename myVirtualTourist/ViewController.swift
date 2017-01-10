//
//  ViewController.swift
//  myVirtualTourist
//
//  Created by Mohammed Ibrahim on 1/6/17.
//  Copyright © 2017 myw. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class ViewController: UIViewController, MKMapViewDelegate,UIGestureRecognizerDelegate, NSFetchedResultsControllerDelegate
{
    
    @IBOutlet var mapView: MKMapView!

    var isInitRegionSet = false

    // MARK: - Instance Variables
    lazy var frcPin: NSFetchedResultsController<Pin> = { () -> NSFetchedResultsController<Pin> in
        
        let fetchRequest = NSFetchRequest<Pin>(entityName: "Pin")
        fetchRequest.sortDescriptors = []
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    var sharedContext = CoreDataStackManager.sharedInstance().managedObjectContext!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapView.delegate = self
        
        // This sets up the tap gesture recognizer
        let tapnHold : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didDelayedTap))
        tapnHold.delegate = self
        tapnHold.numberOfTapsRequired = 0
        tapnHold.minimumPressDuration = 1
        mapView.addGestureRecognizer(tapnHold)

        //Load the Pins
        do {
            try frcPin.performFetch()
        } catch {
            print("testing")
        }
        
        if let count = frcPin.fetchedObjects?.count {
            for pin in frcPin.fetchedObjects! {
                self.addAnnotationToMap(lon: pin.lon, lat: pin.lat)
            }
        }

        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Restore the Last Saved Region
        self.restoreLastMapRegion()
        
        //Load Saved Pin to the Map
    }

    //Detect the Region Change to Save the Region
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        //Set the Current Region only when Region change occurs as a result of user action
        saveCurrentMapRegion()
    }
    
    //Function for Enabling Pin Tap
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        guard !(annotation is MKUserLocation) else { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin") as? MKPinAnnotationView
        annotationView?.canShowCallout = false
        
        return annotationView
    }
    
    //Pin is Tapped/Selected
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

        let pinPred = NSPredicate(format: "lon == %lf AND lat == %lf ",(view.annotation?.coordinate.longitude)!,(view.annotation?.coordinate.latitude)!)

        
        frcPin.fetchRequest.predicate = pinPred
        
        do {
            try frcPin.performFetch()
        } catch {
            print(error)
        }
        
        //Transition to the PhotoViewController
        for newPin in (frcPin.fetchedObjects)! {
            //Set the Current Pin selection
            Common.shared.currentPin = newPin
            performSegue(withIdentifier: "photoCollection", sender: self)
            mapView.deselectAnnotation(view.annotation, animated: false)
            return
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //  action for tapnHold:
    func didDelayedTap(gestureRecognizer: UILongPressGestureRecognizer) {
        
        let client : FlickrClient = FlickrClient()
        
        // Here touch began and user has to hold it for require time (the time limit is assign in viewDidLoad in tapnHold.miniumPressDuration.
        if gestureRecognizer.state == UIGestureRecognizerState.began {
            var touchPoint = gestureRecognizer.location(in: self.mapView)
            var newCoordinates = self.mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = newCoordinates
            
            self.mapView.addAnnotation(annotation)
            
            //Persist the Pin
            let newPin :Pin = Pin(lon: annotation.coordinate.longitude, lat: annotation.coordinate.latitude, title: "test", context: sharedContext)
            sharedContext.insert(newPin)
            client.addPhotoToPin(newPin: newPin)
            
        }
    }
    
    func addAnnotationToMap(lon: Double, lat: Double) {
        var newCoordinates = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = newCoordinates
        self.mapView.addAnnotation(annotation)

    }

    func restoreLastMapRegion() {
        if !self.isInitRegionSet {
            if let initRegion = UserDefaults.standard.object(forKey:"lastRegionAndZoom") as? [String: Double] {
                let center = CLLocationCoordinate2D(latitude: initRegion["centerLat"]!, longitude: initRegion["centerLong"]!)
                let span = MKCoordinateSpan(latitudeDelta: initRegion["deltaLat"]!, longitudeDelta: initRegion["deltaLong"]!)
                self.mapView.region = MKCoordinateRegion(center: center, span: span)
            }
            isInitRegionSet = true
        }
    }
    
    func saveCurrentMapRegion() {
        if isUserGesture() {
            let currentRegion = [
                "centerLat": mapView.region.center.latitude,
                "centerLong": mapView.region.center.longitude,
                "deltaLat": mapView.region.span.latitudeDelta,
                "deltaLong":mapView.region.span.longitudeDelta
            ]
            UserDefaults.standard.setValue(currentRegion, forKey: "lastRegionAndZoom")
        }
        
    }

    func isUserGesture() -> Bool {
        let view = self.mapView.subviews[0]
        //  Look through gesture recognizers to determine whether this region change is from user interaction
        if let gestures = view.gestureRecognizers {
            for gesture in gestures {
                if (gesture.state == UIGestureRecognizerState.began || gesture.state == UIGestureRecognizerState.ended) {
                    return true
                }
            }
        }
        return false
    }

}

