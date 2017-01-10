//
//  PhotoViewController.swift
//  myVirtualTourist
//
//  Created by Mohammed Ibrahim on 1/7/17.
//  Copyright © 2017 myw. All rights reserved.
//

import UIKit

import CoreData
import MapKit


class PhotoViewController : UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, NSFetchedResultsControllerDelegate, MKMapViewDelegate {
    

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var photoCollView: UICollectionView!
    
    @IBOutlet var cellActivity: UIActivityIndicatorView!
    var cellImage = ""
    let reuseIdentifier = "collectionViewCell"
    
    //fileprivate let itemsPerRow: CGFloat = 3
   // fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)

    
    var sharedContext = CoreDataStackManager.sharedInstance().managedObjectContext!
   
    

    lazy var frcPin: NSFetchedResultsController<Photo> = { () -> NSFetchedResultsController<Photo> in
        let myPin = Common.shared.currentPin
        let fetchRequest = NSFetchRequest<Photo>(entityName: "Photo")
        fetchRequest.sortDescriptors = []
        
        fetchRequest.predicate = NSPredicate(format: "pin == %@", myPin!)
        let fetchedResultsController = NSFetchedResultsController<Photo>(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()        
       mapView.delegate = self
       photoCollView.delegate = self
       photoCollView.dataSource = self
        
       //Add the Pin to Map and Center the Pin
        let tempAnnotation : MKPointAnnotation = addAnnotationToMap(lon: Common.shared.currentPin!.lon, lat: Common.shared.currentPin!.lat)
        mapView.setCenter(tempAnnotation.coordinate, animated: false)
        
        frcPin.delegate = self
        
        //Load the Pins
        do {
            try frcPin.performFetch()
        } catch {
            print("testing")
        }
    }

    @IBAction func NewCollection(_ sender: AnyObject) {
          //Erase all photos from the Pin
        if let myPin = Common.shared.currentPin {
                let client = FlickrClient.sharedInstance()
                myPin.removeFromPhoto((myPin.photo)!)
                client.addPhotoToPin(newPin: myPin)
            
        }
    }

    //CollectionView Data Souce Implementation
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return (frcPin.fetchedObjects?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier, for: indexPath) as! FlickrImageCell
        
        let photo : Photo = frcPin.object(at: indexPath)
        if let data : NSData = photo.image {
           cell.FlickrImage.image = UIImage(data: data as Data)
           cell.myPhoto = photo
        } else {
            loadImage(url: URL(string: photo.url!)!, indexPath: indexPath, cell: cell)
        }
        
        //cell.backgroundColor = UIColor.black
        return cell
    }
    

    func addAnnotationToMap(lon: Double, lat: Double) -> MKPointAnnotation {
        var newCoordinates = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = newCoordinates
        self.mapView.addAnnotation(annotation)
        return annotation
    }
    
    
    func loadImage(url: URL, indexPath: IndexPath, cell: FlickrImageCell) {
        cell.actCell.startAnimating()
        let downloadTask:URLSessionDownloadTask =
            URLSession.shared.downloadTask(with: url)
            { (url, urlResponse, error) in
                
                let photo = self.frcPin.object(at: indexPath)
                
                do {
                    try photo.image = Data(contentsOf: URL(string: photo.url!)!) as NSData?
                    cell.FlickrImage.image = UIImage(data: photo.image as! Data)
                    cell.myPhoto = photo
                } catch {
                    print("Unable to Download \(photo.url)")
                }
                cell.actCell.stopAnimating()
            }
        downloadTask.resume()
    }
    
    
    //CollectionView Refresh
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                photoCollView.insertItems(at: [indexPath as IndexPath])
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                photoCollView.deleteItems(at: [indexPath as IndexPath])
            }
            break;
        case .update:
            if let indexPath = indexPath {
                photoCollView.reloadItems(at: [indexPath])
            }
            break;
        case .move:
            break;
        }
    }
    
}

