//
//  ResultsViewController.swift
//  ruvve-ios
//
//  Created by MINJU on 2021/10/05.
//

import UIKit
import CoreLocation

protocol ResultsViewControllerDelegate: AnyObject {
    func didTapPlace(with coordinates:CLLocationCoordinate2D,with namePlace : String)
}
 
class ResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: ResultsViewControllerDelegate?
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var places: [Place] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("----ResultsViewController----")
        view.addSubview(tableView)
        view.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    public func update(with places: [Place]){
        self.tableView.isHidden = false
        self.places = places
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = places[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.isHidden = true
        let place = places[indexPath.row]
        let placeName = place.name
        print(place)
        GooglePlacesManager.shared.resolveLocation(for: place){ [weak self] result in
            switch result{
            case .success(let coordinate):
                DispatchQueue.main.async{
                    self?.delegate?.didTapPlace(with: coordinate, with : placeName)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

}
