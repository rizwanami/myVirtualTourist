//
//  PhotoViewController.swift
//  myVirtualTourist
//
//  Created by Mohammed Ibrahim on 1/7/17.
//  Copyright © 2017 myw. All rights reserved.
//

import UIKit

import CoreData


class PhotoViewController : UICollectionViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet var photoCollView: UICollectionView!
    
    let reuseIdentifier = "collectionViewCell"
    
    fileprivate let itemsPerRow: CGFloat = 3
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)

    
    var sharedContext = CoreDataStackManager.sharedInstance().managedObjectContext!
   
    

    lazy var frcPin: NSFetchedResultsController<Photo> = { () -> NSFetchedResultsController<Photo> in
        let myPin = Common.shared.currentPin?.selectedPin
        let fetchRequest = NSFetchRequest<Photo>(entityName: "Photo")
        fetchRequest.sortDescriptors = []
        
        fetchRequest.predicate = NSPredicate(format: "pin == %@", myPin!)
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()        
        
        //Load the Pins
        do {
            try frcPin.performFetch()
        } catch {
            print("testing")
        }
    }

    
}

// MARK: - UICollectionViewDataSource
extension PhotoViewController {
    //1
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //2
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (frcPin.fetchedObjects?.count)!
    }
    
    //3
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.backgroundColor = UIColor.black
        
        // Configure the cell
        
        
        
        return cell
    }
}


extension PhotoViewController : UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

