//
//  SearchController.swift
//  test_searchbar
//
//  Created by MINJU on 2021/10/09.
//

import UIKit
import MapKit

protocol AddContactDelegate {
    func addStartContact(contact : Contact)
    func addEndContact(contact : Contact)
    
}

class SearchController: UIViewController, UISearchResultsUpdating{

    var delegate : AddContactDelegate?
    
    let mapView = MKMapView()
    
    let searchVC = UISearchController(searchResultsController: ResultsViewController())
    
    var locPoint = CLLocationCoordinate2D()
    var placeName : String = ""
    var flag : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("flag")
        print(flag)

        title = "Ruvve"
        view.addSubview(mapView)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(named: "ruvve_purple")]
        
        //nav back button hide
        self.navigationItem.setHidesBackButton(true, animated: true);
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone));
        print("=======SearchController=========")
        
//        searchVC.searchBar.backgroundColor = .secondarySystemBackground
        searchVC.searchBar.backgroundColor = .white
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = view.bounds
    }

    func updateSearchResults(for searchController: UISearchController) {
        print("===update-=====")
        guard let query = searchController.searchBar.text,!query.trimmingCharacters( in: .whitespaces).isEmpty,
              let resultsVC = searchController.searchResultsController as? ResultsViewController else {
                  return
              }
        print(query)
        
        resultsVC.delegate = self
        GooglePlacesManager.shared.findPlaces(query: query){ result in
            switch result {
            case .success(let places):
                print("========success found results")
                DispatchQueue.main.async{
                    resultsVC.update(with: places)
                }
            case .failure(let error):
                print("========error")
                print(error)
            }
        }
    }
    
    @objc func handleDone(_ sender: Any) {
        print("====Done Click====")
        if (flag == "start") {
            let contact = Contact(addressData: placeName, point: locPoint)
            
            print("======contactData:")
            print(contact.addressData)
            
            delegate?.addStartContact(contact: contact)
        }
        if (flag == "end") {
            let contact = Contact(addressData: placeName, point: locPoint)
            
            print("======contactData:")
            print(contact.addressData)
            
            delegate?.addEndContact(contact: contact)
        }
    }
    
}

extension SearchController: ResultsViewControllerDelegate{
    func didTapPlace(with coordinates: CLLocationCoordinate2D, with namePlace : String) {
        
        searchVC.searchBar.resignFirstResponder()
        searchVC.dismiss(animated: true, completion: nil)
        
        print("검색장소 click")
        
        // Remove all map pins
        let annotations  = mapView.annotations
        mapView.removeAnnotations(annotations)
        
        // Add a map pin
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        print("=====pin=====")
        print(pin.coordinate)
        
        locPoint = pin.coordinate
        placeName = namePlace
        
        mapView.addAnnotation(pin)
        mapView.setRegion(MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: true)
        
    }
}
