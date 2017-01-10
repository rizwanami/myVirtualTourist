//
//  Photo+CoreDataProperties.swift
//  myVirtualTourist
//
//  Created by Mohammed Ibrahim on 1/9/17.
//  Copyright © 2017 myw. All rights reserved.
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo");
    }

    @NSManaged public var farmId: String?
    @NSManaged public var id: String?
    @NSManaged public var image: NSData?
    @NSManaged public var photoTitle: String?
    @NSManaged public var secret: String?
    @NSManaged public var serverId: String?
    @NSManaged public var url: String?
    @NSManaged public var pin: Pin?

}
