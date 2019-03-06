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

class CitiesListViewController: UITableViewController, UISearchResultsUpdating {
    
    let progressHUD = ProgressIndicator(text: "Loading..")
    //Tableview Datasource
    var cities : [City]?
    weak var delegate: MapViewDelegate?
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet var citiesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        configureView()
    }
    
    func configureView() {
        definesPresentationContext = true
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        }
        else {
            tableView.tableHeaderView = searchController.searchBar
        }
        
        searchController.searchResultsUpdater = self as UISearchResultsUpdating
        searchController.searchBar.placeholder = "Search cities"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let _ = cities {
            
        } else {
            self.view.addSubview(progressHUD)
            self.view.backgroundColor = UIColor.white
            self.getSortedCities()
        }
    }
    
    fileprivate func getSortedCities()  {
        return DataHelper.sortCityNames { [weak self](citiesList) -> Void in
            DispatchQueue.main.async {
                if citiesList.count > 0 {
                    self?.cities = citiesList
                    DataHelper.shared.sortedCitiesInfo = citiesList
                    self?.citiesTableView.reloadData()
                    self?.progressHUD.removeFromSuperview()
                    
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
    
    // MARK: - Keyboard hide/show methods
    
    @objc func keyboardWillShow(_ notification: Foundation.Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            tableView.contentInset = edgeInsets
            tableView.scrollIndicatorInsets = edgeInsets
        }
    }
    
    @objc func keyboardWillHide(_ notification: Foundation.Notification) {
        tableView.contentInset = .zero
        tableView.scrollIndicatorInsets = .zero
    }
    
    //Search view delegate
    func updateSearchResults(for searchController: UISearchController) {
        
        //Binary search to filter out results
        guard let searchText = searchController.searchBar.text, searchText != "" else {
            return
        }
        self.cities = DataHelper.filter(from: self.cities ?? [], for: searchText)
        self.citiesTableView.reloadData()
    }
}
