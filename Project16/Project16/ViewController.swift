//
//  ViewController.swift
//  Project16
//
//  Created by Karen Lima on 19/09/21.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Map Type", style: .plain, target: self, action: #selector(mapMenu))
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics", wikiURL: "https://en.wikipedia.org/wiki/London")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.85, longitude: 10.75), info: "Found over a thousand years ago", wikiURL: "https://en.wikipedia.org/wiki/Oslo")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light", wikiURL: "https://en.wikipedia.org/wiki/Paris")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.", wikiURL: "en.wikipedia.org/wiki/Rome")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.", wikiURL: "https://en.wikipedia.org/wiki/Washington")
        mapView.addAnnotations([london, oslo, paris, rome, washington])
        
    }
    @objc func mapMenu(){
        let ac = UIAlertController(title: "Map Type", message: "Choose Map Type", preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Sattelite", style: .default, handler: chooseMap))
        ac.addAction(UIAlertAction(title: "Hybrid", style: .default, handler: chooseMap))
        ac.addAction(UIAlertAction(title: "Hybrid Flyover", style: .default, handler: chooseMap))
        ac.addAction(UIAlertAction(title: "Muted Standard", style: .default, handler: chooseMap))
        ac.addAction(UIAlertAction(title: "Satellite Flyover", style: .default, handler: chooseMap))
        ac.addAction(UIAlertAction(title: "Standard", style: .default, handler: chooseMap))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func chooseMap(action: UIAlertAction){
        guard let actionTitle = action.title else { return }
        print(actionTitle)
        switch actionTitle {
        case "Sattelite":
            mapView.mapType = .satellite
        case "Hybrid":
            mapView.mapType = .hybrid
        case "Hybrid Flyover":
            mapView.mapType = .hybridFlyover
        case "Muted Standard":
            mapView.mapType = .mutedStandard
        case "Satellite Flyover":
            mapView.mapType = .satelliteFlyover
        case "Standard":
            mapView.mapType = .standard
        default:
            mapView.mapType = .standard
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil}
        let identifier = "Capital"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
            
        } else {
            annotationView?.annotation = annotation
        }
        
        if let annotationView = annotationView as? MKMarkerAnnotationView{
            annotationView.markerTintColor = .blue
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        
        let placeName = capital.title
        let placeInfo = capital.info
        
        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Wikipedia", style: .default, handler: { [weak self] _ in
                                    self?.openWiki(url: capital.wikiURL)
        }))
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func openWiki(url: String){
        if let vc = storyboard?.instantiateViewController(withIdentifier: "WebViewController") as? WebViewController {
            vc.url = url
            navigationController?.pushViewController(vc, animated: true)
        }
    }


}

