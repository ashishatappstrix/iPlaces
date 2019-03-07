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
    
    //Outlets
    @IBOutlet var citiesTableView: UITableView!
    
    //Member variables/constants
    let progressHUD = ProgressIndicator(text: "Loading..")
    let dataHelper = DataHelper()
    var cities : [City]?
    weak var delegate: MapViewDelegate?
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerForKeyboardNotifications()
        configureView()
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func configureView() {
        definesPresentationContext = true
        self.citiesTableView.contentInsetAdjustmentBehavior = .automatic
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.hidesSearchBarWhenScrolling = false
            navigationItem.searchController = searchController
        }
        else {
            tableView.tableHeaderView = searchController.searchBar
        }
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Places"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //On view will appear, if there no cities, load it from helper class
        guard let _ = cities else {
            self.view.addSubview(progressHUD)
            self.view.backgroundColor = UIColor.white
            self.getSortedCities()
            return
        }
    }
    
    //Get all sorted cities information from Helper
    fileprivate func getSortedCities()  {
        let timeTaken = dataHelper.duration {
            return dataHelper.sortCityNames { [weak self](citiesList) -> Void in
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
        
        print("Time take for func getSortedCities(): \(timeTaken)")
    }
    
     // MARK: - Tableview Datasource
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
    
     // MARK: - Tableview Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let city = cities?[indexPath.row] else {
            return
        }
        delegate?.citySelected(city)
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
    
    // MARK: Search Controller Delegate Method
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, searchText != "" else {
            self.cities = DataHelper.shared.sortedCitiesInfo
            self.citiesTableView.reloadData()
            return
        }
        
        let timeTaken = dataHelper.duration {
            self.cities = dataHelper.filter(from: DataHelper.shared.sortedCitiesInfo ?? [], for: searchText)
            self.citiesTableView.reloadData()
        }
        print("Time take to filter string: String: \(searchText), Time:  \(timeTaken)")
    }
}
