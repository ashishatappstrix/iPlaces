//
//  AppDelegate.swift
//  iPlaces
//
//  Created by Ashh on 3/4/19.
//  Copyright © 2019 Ashh. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard let splitViewController = window?.rootViewController as? UISplitViewController,
            let leftNavController = splitViewController.viewControllers.first as? UINavigationController,
            let citiesListViewController = leftNavController.topViewController as? CitiesListViewController,
            let rightNavController = splitViewController.viewControllers.last as? UINavigationController,
            let mapViewController = rightNavController.topViewController as? MapViewController
            else { fatalError() }
        
        let firstCity = citiesListViewController.cities?.first
        mapViewController.city = firstCity
        
        citiesListViewController.delegate = mapViewController
        
        mapViewController.navigationItem.leftItemsSupplementBackButton = true
        mapViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        
        return true
    }
}

