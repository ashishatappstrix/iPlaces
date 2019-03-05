//
//  CitiesListViewController.swift
//  iPlaces
//
//  Created by Ashh on 3/4/19.
//  Copyright © 2019 Ashh. All rights reserved.
//

import UIKit

protocol MapViewDelegate: class {
    func citySelected(_ city: City)
}

class CitiesListViewController: UITableViewController {
    
    //Tableview Datasource
    var cities : [City]?
    
    var firstCity: City?
    
    weak var delegate: MapViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.getSortedCities()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let _ = cities {
            
        } else {
            self.getSortedCities()
        }
    }
    
    fileprivate func getSortedCities()  {
        return DataHelper.sortCityNames { [weak self](citiesList) -> Void in
            DispatchQueue.main.async {
                if citiesList.count > 0 {
                    self?.cities = citiesList
                    self?.firstCity = citiesList[0]
                    self?.tableView.reloadData()
                } else {
                    self?.cities = nil
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let cities = cities else {
            return 0
        }
        return cities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        
        guard let city = cities?[indexPath.row] else  {
            return cell
        }
        
        cell.textLabel?.text = city.nameAndCountry
        cell.detailTextLabel?.text = city.coord.details
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = cities?[indexPath.row]
        delegate?.citySelected(city!)
        if let mapViewController = delegate as? MapViewController,
            let mapNavigationController = mapViewController.navigationController {
            splitViewController?.showDetailViewController(mapNavigationController, sender: nil)
        }
    }
}
