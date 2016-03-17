//
//  ViewController.swift
//  Map-Demo
//
//  Created by Nathan Kleven on 3/14/16.
//  Copyright © 2016 Nathan Kleven. All rights reserved.
//

import UIKit
import MapKit



class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var manager: CLLocationManager!
    @IBOutlet weak var updateSwitchStatus: UISwitch!
    
    @IBAction func updateSwitch(sender: AnyObject) {
        
        if updateSwitchStatus.on {
            manager.startUpdatingLocation()
        }else{
            manager.stopUpdatingLocation()
        }
        
    }
    @IBOutlet var latLabel: UILabel!
    @IBOutlet var lonLable: UILabel!
    @IBOutlet var courseLabel: UILabel!
    @IBOutlet var speedLabel: UILabel!
    @IBOutlet var altitudeLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        
        //Populate ViewController Labels
        let userLocation: CLLocation = locations[0]
        self.latLabel.text = "\(userLocation.coordinate.latitude)"
        self.lonLable.text = "\(userLocation.coordinate.longitude)"
        self.courseLabel.text = "\(userLocation.course)"
        self.speedLabel.text = "\(userLocation.speed)"
        self.altitudeLabel.text = "\(userLocation.altitude)"
        
        //Find nearest address and update address label
        CLGeocoder().reverseGeocodeLocation(userLocation, completionHandler: { (placemarks, error) -> Void in
            if (error != nil){
                print(error)
            }
            else
            {
                if let p = placemarks?[0]{
                    
                    var subThoroughfare:String = ""
                    var thoroughfare:String = ""
                    
                    if (p.subThoroughfare != nil) {
                        subThoroughfare = p.subThoroughfare!
                    }
                    if (p.thoroughfare != nil){
                        thoroughfare = p.thoroughfare!
                    }

                    //let subLocality:String = p.subLocality!
                    let locality:String = p.locality!
                    let postalCode:String = p.postalCode!
                    let country:String = p.country!
                    let state:String = p.administrativeArea!
                    
                    self.addressLabel.text = "\(subThoroughfare) \(thoroughfare) \n \(locality), \(state) \(postalCode) \n \(country)"
                    
                    // \(subLocality)
                }
            }
                    
        })

        
        //Update Map with Current Location
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude)
        let spanValue:CLLocationDegrees = 0.01
        let span:MKCoordinateSpan = MKCoordinateSpanMake(spanValue, spanValue)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        self.map.setRegion(region, animated: false)
        
    }

    func setLocation() -> Void {
        
        let lattitude:CLLocationDegrees = 40.7
        let longitude:CLLocationDegrees = -73.9
        let latDelta:CLLocationDegrees = 0.01
        let lonDelta:CLLocationDegrees = 0.01
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta,lonDelta)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lattitude, longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        map.setRegion(region, animated: false)  //MKMapView Object
    }

}

