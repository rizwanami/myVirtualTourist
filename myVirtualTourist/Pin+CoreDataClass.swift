//
//  Pin+CoreDataClass.swift
//  myVirtualTourist
//
//  Created by Mohammed Ibrahim on 1/6/17.
//  Copyright © 2017 myw. All rights reserved.
//

import Foundation
import CoreData


public class Pin: NSManagedObject {
    convenience init(lon : Double, lat: Double, title: String, context : NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "Pin", in: context) {
            self.init(entity : ent , insertInto : context)
            self.title = title
            self.lat = lat
            self.lon = lon
        } else {
            fatalError("Unable to find the entity name")
        }
    }
}
