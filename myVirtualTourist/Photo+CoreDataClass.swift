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
    
    convenience init(id : String, farmId : String, secret: String,serverId : String, title : String, context : NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "Photo", in: context) {
            self.init(entity : ent , insertInto : context)
            self.farmId = farmId
            self.id = id
            self.secret=secret
            self.serverId=serverId
            self.photoTitle=title
            self.url="https://farm\(farmId).staticflickr.com/\(serverId)/\(id)_\(secret).jpg"
        } else {
            fatalError("Cannot Instantiate Photo")
        }
    }

}
