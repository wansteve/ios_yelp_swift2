//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate, UISearchBarDelegate {
    
    // implement these two protocols to set data source and capture table view events
    
    // declare myself, BusinessViewController as a delegate of the filtersviewcontroller in the last paratemter

    var businesses: [Business]! // where is the class Business defined?

    lazy   var searchBars:UISearchBar = UISearchBar(frame: CGRectMake(0, 0, 200, 20))

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        var rightNavBarButton = UIBarButtonItem(customView: searchBars)
        // self.navigationItem.leftBarButtonItem = leftNavBarButton
       //  self.navigationItem.titleView = leftNavBarButton
        //self.navigationItem.rightBarButtonItem = rightNavBarButton

        self.searchBars = UISearchBar()
        searchBars.delegate = self

        searchBars.placeholder = "e.g. Thai, Restaurants"
        self.navigationItem.titleView = searchBars
        
        
        
        // initialize tableview with the following 2 lines
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        
        
        Business.searchWithTerm(searchBars.text, completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData() // if table is blank, need to add this reload inside viewDidLoad()
           
            for business in businesses {
                println(business.name!)
                println(business.address!)
            }
        })
        
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            for business in businesses {
                println(business.name!)
                println(business.address!)
            }
        }
    } // end of viewDidLoad
    

    func searchBarSearchButtonClicked(searchBars: UISearchBar) {
        // self.clearResults()
        // self.performSearch(searchBars.text)
        
        println("search bar changed")
        Business.searchWithTerm(searchBars.text, completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData() // if table is blank, need to add this reload inside viewDidLoad()
            
            for business in businesses {
                println(business.name!)
                println(business.address!)
            }
        })
    }// searchBarSearchButton

    
/*
    func clearResults() {
        self.results = []
        self.offset = 0
        self.onResultsCleared()
    }
*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (businesses != nil) {
            return businesses.count
        } else {
            return 0
        }
    } // numberOfRowsInSection
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        
        cell.business = businesses[indexPath.row]
        return cell
        
    }// cellForRowAtIndexPath
    
    

    // when filter button is hit, right before transition, setting myself up
    // businessview controller is the originating thing for the filter delegate
    // set myself up as the delgate

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        // Grab the destination view controller which is the UINavigationController
        
        let navigationController = segue.destinationViewController as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        
        // finally set myself as the filters delegate
        filtersViewController.delegate = self
        
    } // prepareForSegue
    


    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        
        var categories = filters["categories"] as? [String]
        
        //Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
         // var deals = filters["deals"] as? Bool
         // var sort = filters["sort") as? [String]
        
        //         Business.searchWithTerm("Restaurants", sort: nil, categories: categories, deals: nil) {(businesses: [Business]!, error: NSError!) -> Void in

        
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: categories, deals: nil) {(businesses: [Business]!, error: NSError!) -> Void in
        self.businesses = businesses
        self.tableView.reloadData()

    
    
        }
    }

} // end of BusinessViewController
