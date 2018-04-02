//
//  MapViewController.swift
//  VK
//
//  Created by Maxim Tolstikov on 31/03/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let longPressGestureRecognize = UILongPressGestureRecognizer(target: self, action: #selector(longTapp(press:)))
        longPressGestureRecognize.minimumPressDuration = 2.0
        map.addGestureRecognizer(longPressGestureRecognize)
        
        map.showsUserLocation = true

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()

    }
    
    @objc func longTapp(press: UILongPressGestureRecognizer) {
        if press.state == .began {
            let location = press.location(in: map)
            let coordinate = map.convert(location, toCoordinateFrom: map)
            print("cootrdinates: \(coordinate.latitude)")
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coordinate, 2000, 2000)
            map.setRegion(region, animated: true)
        }
        
        
    }
}
