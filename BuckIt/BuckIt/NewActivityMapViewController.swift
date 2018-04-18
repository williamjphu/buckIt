//
//  NewActivityMapViewController.swift
//  BuckIt
//
//  Created by Joshua Ventocilla on 4/15/18.
//  Copyright © 2018 Samnang Sok. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearch: class {
    func dropPinZoomIn(_ placemark:MKPlacemark)
}

class NewActivityMapViewController: UIViewController {
    var selectedPin: MKPlacemark?
    var resultSearchController: UISearchController!
    var locationN: String?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
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
        locationSearchTable.handleMapSearchDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let coordinate = selectedPin?.coordinate
        let locationName = selectedPin?.name
        print("\n\nCoordinate \(coordinate)")
        print("Name: \(locationName)")
        locationN = locationName
        locationLabel.text = locationName
    }
    
}

extension NewActivityMapViewController: HandleMapSearch {
    
    func dropPinZoomIn(_ placemark: MKPlacemark){
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
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
    
}


// OLD CODE BY JOSH 
//extension NewActivityMapViewController: UISearchBarDelegate {
//    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        searchCompleter.queryFragment = searchText
//    }
//}
//
//extension NewActivityMapViewController: MKLocalSearchCompleterDelegate {
//    
//    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
//        searchResults = completer.results
//        searchResultsTableView.reloadData()
//    }
//    
//    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
//        // handle error
//    }
//}
//
//extension NewActivityMapViewController: UITableViewDataSource {
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return searchResults.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let searchResult = searchResults[indexPath.row]
//        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
//        cell.textLabel?.text = searchResult.title
//        cell.detailTextLabel?.text = searchResult.subtitle
//        return cell
//    }
//}
//
//extension NewActivityMapViewController: UITableViewDelegate {
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        
//        let completion = searchResults[indexPath.row]
//        
//        let searchRequest = MKLocalSearchRequest(completion: completion)
//        let search = MKLocalSearch(request: searchRequest)
//        search.start { (response, error) in
//            let coordinate = response?.mapItems[0].placemark.coordinate
//            print(String(describing: coordinate))
//        }
//    }
//}
