//
//  Photo+CoreDataClass.swift
//  myVirtualTourist
//
//  Created by Mohammed Ibrahim on 1/6/17.
//  Copyright © 2017 myw. All rights reserved.
//

import Foundation
import CoreData


public class Photo: NSManagedObject {
    convenience init(text : String, context : NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "Photo", in: context) {
            self.init(entity : ent , insertInto : context)
            
        } else {
            fatalError("Cannot Instantiate Photo")
        }
    }

}
