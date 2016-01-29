//
//  VCMapView.swift
//  HonoluluArt
//
//  Created by Wei Mun Yap on 13/01/2016.
//  Copyright © 2016 Wei Mun Yap. All rights reserved.
//

import Foundation
import MapKit

extension ViewController: MKMapViewDelegate {
    
    //  This is the method that gets called for every annotation you add to the map to return the view for each annotation.
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let annotation = annotation as? Artwork{
            let identifier = annotation.discipline
            var view: MKPinAnnotationView
            
            //  Map views are set up to reuse annotation views when some are no longer visible. So the code first checks to see if a reusable annotation view is available before creating a new one.
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.animatesDrop = true
                view.canShowCallout = true
                
                switch identifier {
                    case "Sculpture", "Plaque":
                        view.pinTintColor = UIColor.redColor()
                    case "Mural", "Monument":
                        view.pinTintColor = UIColor.purpleColor()
                    default:
                        view.pinTintColor = UIColor.greenColor()
                }
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            }
            return view
        }
        return nil
    }
    
    // When the user taps a map annotation pin, the callout shows an info button. If the user taps this info button, this method is called.
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        /* Grab the Artwork object that this tap refers to and then launch the Maps app by creating an associated MKMapItem and calling openInMapsWithLaunchOptions on the map item.
        Notice you’re passing a dictionary to this method. This allows you to specify a few different options; here the DirectionModeKeys is set to Driving. This will make the Maps app try to show driving directions from the user’s current location to this pin
        */
        let location = view.annotation as! Artwork
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMapsWithLaunchOptions(launchOptions)
    }
}
