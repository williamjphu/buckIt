//
//  chooseMapViewController.swift
//  BuckIt
//
//  Created by Michael Hyun on 5/1/18.
//  Copyright © 2018 Samnang Sok. All rights reserved.
//


import UIKit
import MapKit

protocol chooseMapViewControllerDelegate: class {
    func dropPinZoom(_ placemark: MKPlacemark)
}

class chooseMapViewController: UIViewController, LocationSearchTableDelegate {
    weak var delegate : chooseMapViewControllerDelegate?
    var selectedPin: MKPlacemark?
    var resultSearchController: UISearchController!
    var locationN: String?
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        locationSearchTable.delegate = self
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController.searchResultsUpdater = locationSearchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = mapView
    }
    
    func dropPinZoomIn(_ placemark: MKPlacemark){
        delegate?.dropPinZoom(placemark)
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        
        mapView.addAnnotation(annotation)
        mapView.selectAnnotation(annotation, animated: true)
        let span = MKCoordinateSpanMake(0.075, 0.075)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
        
    }
    
}
