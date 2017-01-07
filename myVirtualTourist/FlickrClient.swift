//
//  FlickrClient.swift
//  myVirtualTourist
//
//  Created by Mohammed Ibrahim on 1/7/17.
//  Copyright © 2017 myw. All rights reserved.
//

import Foundation

class FlickrClient {

    let APIKey = ""
    
    //Get the Shared Instance to the Flicker Client
    class func sharedInstance() -> FlickrClient {
        struct Static {
            static let instance = FlickrClient()
        }
        
        return Static.instance
    }
    
    //
    func FetchPhotosForPin(pin : Pin) -> [Photo] {
        var photos : [Photo] = []
        
        //Fetch Photos and Return Photos
        
        
        return photos
        
    }
    
    func DownLoadPhotosForPin(pin : Pin) {
        
    }
    
    func getSearchURL(lon: Double, lat: Double) {
        
    }

    
}
