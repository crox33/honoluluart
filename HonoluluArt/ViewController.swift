//
//  ViewController.swift
//  HonoluluArt
//
//  Created by Wei Mun Yap on 12/01/2016.
//  Copyright © 2016 Wei Mun Yap. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    // Because that works well for plotting the public artwork data in the JSON file.
    let regionRadius: CLLocationDistance = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set initial location Honolulu.
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        centerMapOnLocation(initialLocation)
        
        // Show artwork on map.
//        let artwork = Artwork(title: "King David Kalakaua", locationName: "Waikiki Gateway Park", discipline: "Sculpture", coordinate: CLLocationCoordinate2D(latitude: 21.283921, longitude: -157.8311661))

        loadInitialData()
        mapView.addAnnotations(artworks)
        
        mapView.delegate = self
    }
    
    
    func centerMapOnLocation(location:CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    var artworks = [Artwork]()
    func loadInitialData() {
        // Read the PublicArt.json file into an NSData object.
        let fileName = NSBundle.mainBundle().pathForResource("PublicArt", ofType: "json")
        var data: NSData?
        do {
            data = try NSData(contentsOfFile: fileName!, options: [])
        } catch _ {
            data = nil
        }
        
        // Use NSJSONSerialization to obtain a JSON object.
        var jsonObject: AnyObject?
        if let data = data {
            do {
                jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: [])
            } catch _ {
                jsonObject = nil
            }
        }
        
        // Check that the JSON object is a dictionary where the keys are Strings and the values can be AnyObject.
        if let jsonObject = jsonObject as? [String: AnyObject],
        
        // Only interested in the JSON object whose key is "data" and you loop through that array of arrays, checking that each element is an array
        let jsonData = JSONValue.fromObject(jsonObject)?["data"]?.array {
            for artworkJSON in jsonData {
                // Pass each artwork’s array to the fromJSON method that you just added to the Artwork class. If it returns a valid Artwork object, you append it to the artworks array.
                if let artworkJSON = artworkJSON.array, artwork = Artwork.fromJSON(artworkJSON) {
                        artworks.append(artwork)
                }
            }
        }
    }
    
    // MARK: - location manager to authorize user location for Maps app.
    var locationManager = CLLocationManager()
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
}

