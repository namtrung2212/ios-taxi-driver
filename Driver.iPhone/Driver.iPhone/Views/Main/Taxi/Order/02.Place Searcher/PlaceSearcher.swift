//
//  MapMarker.swift
//  User.iPhone
//
//  Created by Trung Dao on 4/13/16.
//  Copyright © 2016 SCONNECTING. All rights reserved.
//
import UIKit
import Foundation
import ObjectMapper
import AlamofireObjectMapper
import SClientData
import SClientModel
import CoreLocation
import RealmSwift
import GooglePlaces
import GoogleMaps

extension TravelOrderScreen  {
    
    func initSearchControl(_ completion: (() -> ())?){
        
        placeSearcher.initControls(completion)
    }
    
}
open class PlaceSearcher : NSObject, GMSAutocompleteResultsViewControllerDelegate,UISearchBarDelegate{
    
    var searchResultController: GMSAutocompleteResultsViewController
    var searchController: UISearchController
    
    var parent: TravelOrderScreen
    
    public init(parent: TravelOrderScreen){
        
        self.parent = parent
        self.searchResultController = GMSAutocompleteResultsViewController()
        self.searchController = UISearchController(searchResultsController: self.searchResultController)
    }
    open func initControls(_ completion: (() -> ())?){
        
        searchResultController = GMSAutocompleteResultsViewController()
        searchResultController.delegate = self
        searchResultController.autocompleteFilter?.type = .address
        searchResultController.autocompleteFilter?.country = "vi"

        
        searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchResultsUpdater = searchResultController
        searchController.searchBar.placeholder = "Tìm địa điểm"
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.setValue("Huỷ", forKey: "_cancelButtonText")
        let searchText =  searchController.searchBar.value(forKey: "_searchField") as! UITextField
        searchText.font = searchText.font?.withSize(11)
        searchController.searchBar.sizeToFit()
        searchController.hidesNavigationBarDuringPresentation = false
        
        self.parent.navigationItem.titleView = searchController.searchBar
        self.parent.navigationItem.title = "SCONNECTING"

        self.parent.definesPresentationContext = true
        completion?()
        
    }
    open func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        
        searchController.isActive = false
        self.parent.mapView.gmsMapView.animate(toLocation: place.coordinate)
        
    }
    
    open func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: NSError){
        // TODO: handle the error.
        print("Error: ", error.description)
    }
    
    // Turn the network activity indicator on and off again.
    open func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    open func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    
    open func searchBarTextDidBeginEditing(_ searchBar: UISearchBar){
        self.searchController.searchBar.placeholder = ""
        let neBoundsCorner = CLLocationCoordinate2D(latitude:SCLocationManager.currentLocation!.Location!.coordinate.latitude - 0.1 ,
                                                                                                            longitude:SCLocationManager.currentLocation!.Location!.coordinate.longitude - 0.1)
        let swBoundsCorner = CLLocationCoordinate2D(latitude:SCLocationManager.currentLocation!.Location!.coordinate.latitude + 0.1 ,
                                                    longitude:SCLocationManager.currentLocation!.Location!.coordinate.longitude + 0.1)
        let bounds = GMSCoordinateBounds(coordinate: neBoundsCorner,coordinate: swBoundsCorner)
        
        searchResultController.autocompleteBounds = bounds
    }
    
    
    open func showSearchBar(_ isShow: Bool){
        if(isShow && self.parent.navigationItem.titleView == nil){
            self.parent.navigationItem.titleView = searchController.searchBar
            
        }else if(!isShow && self.parent.navigationItem.titleView != nil){
            self.parent.navigationItem.titleView = nil
        }
        
    }

}
