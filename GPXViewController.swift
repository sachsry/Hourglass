//
//  GPXViewController.swift
//  Hourglass
//
//  Created by Ryan Sachs on 4/18/17.
//  Copyright © 2017 Ryan Sachs. All rights reserved.
//

import UIKit
import MapKit

class GPXViewController: UIViewController, MKMapViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addWaypoints()
    }

    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.mapType = .satellite
            mapView.delegate = self
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var view: MKAnnotationView! = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.AnnotationViewReuseIdentifier)
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Constants.AnnotationViewReuseIdentifier)
            view.canShowCallout = true
        } else {
            view.annotation = annotation
        }
        view.leftCalloutAccessoryView = nil
        view.rightCalloutAccessoryView = nil
        if let waypoint = annotation as? BarWaypoint {
            if waypoint.thumbnailURL != nil {
                view.leftCalloutAccessoryView = UIImageView(frame: Constants.LeftCalloutFrame)
            }
            
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let thumbnailImage = view.leftCalloutAccessoryView as? UIImageView,
            let url = (view.annotation as? BarWaypoint)?.thumbnailURL {
            // Saves the URL and Button for the current annotation
            currentAnnotationURL = url
            currentThumbNailImage = thumbnailImage
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let urlContents = try? Data(contentsOf: url)
                // now that we're back from blocking
                // are we still even interested in this url (i.e. does it == self.currentAnnotationURL)?
                if let imageData = urlContents, url == self?.currentAnnotationURL,
                    let image = UIImage(data:imageData) {
                    // now we want to set the image in the UI
                    // but we are not on the main thread right now
                    // so we are not allowed to do UI
                    // no problem: just dispatch the UI stuff back to the main queue
                    DispatchQueue.main.async {
                        self?.currentThumbNailImage?.image = image
                    }
                }
            }
        }
        
    }
    
    var currentAnnotationURL: URL?
    var currentThumbNailImage: UIImageView?
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            performSegue(withIdentifier: Constants.ViewBarInformation, sender: view)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination.contentViewController
        let annotationView = sender as? MKAnnotationView
        let waypoint = annotationView?.annotation as? BarWaypoint
        
        if segue.identifier == Constants.ViewBarInformation {
            if let vvc = destination as? VisitViewController {
                // do stuff
            }
        }
    }
    
    
    // FOR SCOTTY - See GPXWaypoint - it will show you all information that needs to be stored on back end
    // Simply create an object on the back end that mirrors the BarWaypoint Object
    // Create Waypoints for each BarWaypoint in the database
    private func addWaypoints() {
        var waypoints = [MKAnnotation]()
        
        // let allBars = [query for bars here]
        // for bar in allBars
        // create/add waypoint (you can keep the lines below)
        let point = BarWaypoint(name: "RJ Bentley's", barInfo: "Best Bar in CP", latitude: 38.980481, longitude: -76.937557)
        waypoints.append(point)
        // END
        
        // Keep lines
        mapView?.addAnnotations(waypoints)
        mapView?.showAnnotations(waypoints, animated: true)
        for p in mapView.annotations {
            mapView.selectAnnotation(p, animated: true)
        }
    }
    
    // MARK: Constants
    private struct Constants {
        static let LeftCalloutFrame = CGRect(x: 0, y: 0, width: 59, height: 59)
        static let AnnotationViewReuseIdentifier = "waypoint"
        static let ViewBarInformation = "View Bar Information"
        static let CheckIn = "Check In"
    }

}
