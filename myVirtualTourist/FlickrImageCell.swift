//
//  FlickrImageCell.swift
//  myVirtualTourist
//
//  Created by Mohammed Ibrahim on 1/8/17.
//  Copyright © 2017 myw. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FlickrImageCell: UICollectionViewCell, NSFetchedResultsControllerDelegate{
    
    var myPhoto : Photo?
    
    @IBOutlet var FlickrImage: UIImageView!
    
    @IBOutlet var actCell: UIActivityIndicatorView!
    
    @IBOutlet var ImageButton: UIButton!
    
    @IBAction func btnActionImage(_ sender: AnyObject) {
        //Delete the Image
        let mocMain : CoreDataStackManager = CoreDataStackManager.sharedInstance()
        if let myPhoto = myPhoto {
            mocMain.managedObjectContext?.delete(myPhoto)
            mocMain.saveContext()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
