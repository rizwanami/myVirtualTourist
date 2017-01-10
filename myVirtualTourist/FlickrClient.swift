//
//  FlickrClient.swift
//  myVirtualTourist
//
//  Created by Mohammed Ibrahim on 1/7/17.
//  Copyright © 2017 myw. All rights reserved.
//

import Foundation

struct FlickrSearchField {
    static let apiKey  = "api_key"
    static let longitude  = "lon"
    static let lattitude = "lat"
    static let recordPerPage = "per_page"
}

struct FlickrCommon {
    static let APIKey = "43e24710270cc30c05319974218861de"
    static let FlickrSearchAPI = "flickr.photos.search";
    static let FlickrURL = "https://api.flickr.com/services/rest/"
    static let FlickrSearchURL = "\(FlickrURL)/?method=\(FlickrSearchAPI)&\(FlickrSearchField.apiKey)=\(APIKey)"
}
    


class FlickrClient {

    let sharedSession : URLSession = URLSession.shared
    
    //Get the Shared Instance to the Flicker Client
    class func sharedInstance() -> FlickrClient {
        struct Static {
            static let instance = FlickrClient()
        }
        
        return Static.instance
    }
    
    //
    func FetchPhotosForPin(pin : Pin , completion:@escaping (_ data: [[String : AnyObject]]?, _ error: Error?)-> Void ) -> Void {
        var photos : [Photo] = []
        let lon : Double = pin.lon
        let lat : Double = pin.lat
        
        let apiUrl = "\(FlickrCommon.FlickrSearchURL)&\(FlickrSearchField.longitude)=\(lon)&\(FlickrSearchField.lattitude)=\(lat)&format=json&nojsoncallback=1"
        
        print("URL : \(apiUrl)")
        let task : URLSessionDataTask = sharedSession.dataTask(with: URL(string: apiUrl)!){
            (data, response, error) in
            if error != nil {
                print("error fetching data")
                completion(nil, error)
                return
            }
            
            //JSON Serialization, Converting JSON Data to Photo Array
            let newData = data
            var parsedJsonData: NSDictionary!
            do
            {
                parsedJsonData = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as! NSDictionary
            }
            catch
            {
                print("Unable to parse data : \(error)")
                return
            }
            print(parsedJsonData)
            
            if let flickrPhotos = (parsedJsonData["photos"] as! NSDictionary?)?["photo"] as! [[String: AnyObject]]? {
                print(flickrPhotos)
                completion(flickrPhotos, nil)
                return
            }

            //Call Completion Handle
            completion(nil,"Error fetching data" as! Error)
            return
        }
        task.resume()
        return
    }
    
    func DownLoadPhotoForPhoto(photo : Photo) {
        //Download or Refresh the Photo
    }
    
    func getSearchURL(lon: Double, lat: Double) {
        
    }
    
    //Get Photos for Pin
    func addPhotoToPin(newPin : Pin) {
        self.FetchPhotosForPin(pin: newPin) {
            (data, error) in
            if error != nil {
                print("error fetching the Photos")
                return
            }
            for photo in data! {
                let newPhoto = Photo(id: photo["id"] as! String, farmId: "\(photo["farm"])" as! String, secret: photo["secret"] as! String, serverId: photo["server"] as! String, title: photo["title"] as! String, context: CoreDataStackManager.sharedInstance().managedObjectContext!)
    
                //Add new photo to pin
                newPin.addToPhoto(newPhoto)
            }
            //Save Photos in Pin
            CoreDataStackManager.sharedInstance().saveContext()
        }
    }
    

    
}
