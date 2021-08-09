//
//  MapViewController.swift
//  ogawamachi
//
//  Created on 2021/07/23.
//

import UIKit
import MapKit
import CoreLocation
import SafariServices

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var myLocationManager: CLLocationManager!
    var locations: [Omise] = []
    var type: [Omise]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myLocationManager = CLLocationManager()
        myLocationManager.requestWhenInUseAuthorization()
        
        let center = CLLocationCoordinate2DMake(35.695180, 139.764797)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated:true)
        
        var annotations = [MKPointAnnotation]()
        
        if type != nil {
            locations = type!
        } else {
            locations = omiseData
        }
                
        for location in locations {
            let annotation = MapAnnotationSetting()
            
            // ジオコーディング
//            CLGeocoder().geocodeAddressString(location.住所) { placemarks, error in
//
//                var a: CLLocationDegrees?
//                var b: CLLocationDegrees?
//
//                if let lat = placemarks?.first?.location?.coordinate.latitude {
//                    a = lat
//                }
//                if let lng = placemarks?.first?.location?.coordinate.longitude {
//                    b = lng
//                }
//                annotation.coordinate = CLLocationCoordinate2DMake(a ?? 35.695180, b ?? 139.764797)
//            }
            
            annotation.coordinate = CLLocationCoordinate2DMake(location.緯度, location.経度)
            annotation.title = location.店名
            annotation.subtitle = location.食べログ
            
            switch location.ジャンル {
            case "蕎麦", "ラーメン":
                annotation.pinColor = UIColor.blue
            default:
                annotation.pinColor = UIColor.red
            }
            
            if location.日時 != "-" {
                annotation.pinColor = UIColor.green
            }
                        
            annotations.append(annotation)
            self.mapView.addAnnotation(annotation)
        }
        // 現在地・向きを表示
        mapView.userTrackingMode = .followWithHeading
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("error")
        }
    
    // ピンで表示する
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            
            if let pin = annotation as? MapAnnotationSetting {
                pinView!.pinTintColor = pin.pinColor
            }
            
            pinView?.animatesDrop = false
            pinView?.canShowCallout = true
            let btn = UIButton(type: .detailDisclosure)
            pinView!.rightCalloutAccessoryView = btn
            return pinView
        }
        else {
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let address = (view.annotation?.subtitle)!

//        let ac = UIAlertController(title: "placeName", message: "placeInfo", preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "OK", style: .default))
//        present(ac, animated: true)
        
        let url = URL(string: address!)!
        let safariViewController = SFSafariViewController(url: url)
        self.present(safariViewController, animated: false, completion: nil)
    }
    
}

class MapAnnotationSetting: MKPointAnnotation {
    var pinColor: UIColor = UIColor.red
}
