//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Steve Wan on 5/16/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit


// convention for protocol is class name followed by the word delegate
// when the search button in the filters page is hit, pass back to the business page???
// this is to declare the delegate


@objc protocol FiltersViewControllerDelegate {
    optional func filtersViewController (filtersViewController: FiltersViewController, didUpdateFilters filters: [String:AnyObject])
    
    // filtersViewController is firing the event, and pass back didUpdateFilters
    // it is optional func, because if someone wants to implement it, great, otherwise, not required
    // filters is the local parameter name
}


/* next step
@objc protocol FiltersViewControllerDelegate {
    optional func filtersViewController (filtersViewController: FiltersViewController, didUpdateFilters filters: [String:AnyObject], deal:Bool, radius:Int, sort:Int)
    
}
next step */

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    // now going to have a delegate in response to the protocol FilterViewControllerDelegate
    weak var delegate: FiltersViewControllerDelegate? // ? is for optional, a delegate of type FiltersViewController
    
    // next step
    var isExpended: [Int:Bool]! = [Int:Bool]()
    var selectedDistance = 0
    var selectedSort = 0
    //
    
    var categories: [[String:String]]!
    var switchStates = [Int:Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        categories = yelpCategories()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        // Do any additional setup after loading the view.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onSearchButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        
        // next step
        var deal = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
        
        println ("DDeal is \(deal)")
        var radius = -1
        if selectedDistance == 0 {
            radius = -1
        } else if selectedDistance == 1 {
            radius = 1
        } else {
            radius = 5
        }
        // next step
    
        
        // inside this onSearchButton method, if delegate does exist, then call filtersViewController method and pass back myself and figure something out to pass back, e.g. filters
        var filters = [String : AnyObject]() // this is somewhat arbitrary
        // calling the delegate here
        
        var selectedCategories = [String]() // iterate through my switchStates
        for (row, isSelected) in switchStates { // walk through all rows
            if isSelected {
                selectedCategories.append(categories[row]["code"]!)
            } // isSelected
        } // for (row, isSelected)
        
        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories
        }
        
        delegate?.filtersViewController?(self, didUpdateFilters: filters) // safe1: this is calling the delegate event
        // delegate?.filtersViewController?(self, didUpdateFilters: filters, deal: deal.onSwitch.on, radius: radius, sort: selectedSort)
        // delegate?.filtersViewController?(self, didUpdateFilters: filters, deal: true, radius: radius, sort: selectedSort)
    }
    
    //next step: new
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
       
    /* next step old
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    */
    
    //next step: new
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView = UIView(frame: CGRectMake(0, 0, 320, 40))
        var headerLabel = UILabel(frame: CGRectMake(10, 2, 320, 40))
        headerLabel.textColor = UIColor.grayColor()
        if section == 0 {
            // headerLabel.text = "Deal"
            headerLabel.text = ""
        }
        else if section == 1 {
            headerLabel.text = "Distance"
        }
        else if section == 2 {
            headerLabel.text = "Sort by"
        }
        else {
            headerLabel.text = "Categories"
        }
        headerView.addSubview(headerLabel)
        
        return headerView
    }
 
    //next step -- new
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 || section == 2 {
            if let expanded = isExpended[section] {
                return expanded ? 3 : 1
            } else {
                return 1
            }
        }
        else if section == 3 {
            if let expended = isExpended[section] {
                return expended ? 5 : 4
            } else {
                return categories.count
            }
        }
        return 1
    }
    
    
    /* next step: orginal: the following is where the cell gets populated
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as!SwitchCell
        
        cell.switchLabel.text = categories[indexPath.row]["name"]
        cell.delegate  = self
        
        
        // if switchStates[indexPath.row] != NIL, set it to me, otherwise set to false
        cell.onSwitch.on = switchStates[indexPath.row] ?? false
        return cell
        
    }
next step: original */


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            var cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell") as! SwitchCell
            
            cell.switchLabel.text = "Offering a Deal"
            cell.delegate  = self
            cell.onSwitch.on = switchStates[indexPath.row] ?? false
            
            return cell
        }
            
        else if indexPath.section == 1 {
            var cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell") as! SwitchCell
            
            var rowIndex = 0
            
            cell.switchLabel.text = "Auto"
            cell.delegate  = self
            cell.onSwitch.on = switchStates[indexPath.row] ?? false
            
            /*  next step: this needs to be fixed
            if rowIndex == 0 {
                cell.distanceLabel.text = "Auto"
            }
            else if rowIndex == 1 {
                cell.distanceLabel.text = "1 meter"
            }
            else {
                cell.distanceLabel.text = "5 meters"
            }
            */
            
            return cell
        } // indexPath.section == 1
            
        else if indexPath.section == 2 {
            var cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell") as! SwitchCell
            
            var rowIndex = 0
            cell.switchLabel.text = "Distance"
            cell.delegate  = self
            cell.onSwitch.on = switchStates[indexPath.row] ?? false
            
            
            /*  this needs to be fixed
            if rowIndex == 0 {
                cell.sortedLabel.text = "Best Matched"
            }
            else if rowIndex == 1 {
                cell.sortedLabel.text = "Distance"
            }
            else {
                cell.sortedLabel.text = "Highest Rated"
            }
            */
            
            return cell
        }
            
        else  {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as!SwitchCell
            
            cell.switchLabel.text = categories[indexPath.row]["name"]
            cell.delegate  = self
            
            
            // if switchStates[indexPath.row] != NIL, set it to me, otherwise set to false
            cell.onSwitch.on = switchStates[indexPath.row] ?? false
            return cell
            
        }
    }
    
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPathForCell(switchCell)!
    
switchStates [indexPath.row] = value
    } // switchCell

    func yelpCategories () -> [[String:String]] {

    return [["name" : "Afghan", "code": "afghani"],
        ["name" : "African", "code": "african"],
        ["name" : "American, New", "code": "newamerican"],
        ["name" : "American, Traditional", "code": "tradamerican"],
        ["name" : "Arabian", "code": "arabian"],
        ["name" : "Argentine", "code": "argentine"],
        ["name" : "Armenian", "code": "armenian"],
        ["name" : "Asian Fusion", "code": "asianfusion"],
        ["name" : "Asturian", "code": "asturian"],
        ["name" : "Australian", "code": "australian"],
        ["name" : "Austrian", "code": "austrian"],
        ["name" : "Baguettes", "code": "baguettes"],
        ["name" : "Bangladeshi", "code": "bangladeshi"],
        ["name" : "Barbeque", "code": "bbq"],
        ["name" : "Basque", "code": "basque"],
        ["name" : "Bavarian", "code": "bavarian"],
        ["name" : "Beer Garden", "code": "beergarden"],
        ["name" : "Beer Hall", "code": "beerhall"],
        ["name" : "Beisl", "code": "beisl"],
        ["name" : "Belgian", "code": "belgian"],
        ["name" : "Bistros", "code": "bistros"],
        ["name" : "Black Sea", "code": "blacksea"],
        ["name" : "Brasseries", "code": "brasseries"],
        ["name" : "Brazilian", "code": "brazilian"],
        ["name" : "Breakfast & Brunch", "code": "breakfast_brunch"],
        ["name" : "British", "code": "british"],
        ["name" : "Buffets", "code": "buffets"],
        ["name" : "Bulgarian", "code": "bulgarian"],
        ["name" : "Burgers", "code": "burgers"],
        ["name" : "Burmese", "code": "burmese"],
        ["name" : "Cafes", "code": "cafes"],
        ["name" : "Cafeteria", "code": "cafeteria"],
        ["name" : "Cajun/Creole", "code": "cajun"],
        ["name" : "Cambodian", "code": "cambodian"],
        ["name" : "Canadian", "code": "New)"],
        ["name" : "Canteen", "code": "canteen"],
        ["name" : "Caribbean", "code": "caribbean"],
        ["name" : "Catalan", "code": "catalan"],
        ["name" : "Chech", "code": "chech"],
        ["name" : "Cheesesteaks", "code": "cheesesteaks"],
        ["name" : "Chicken Shop", "code": "chickenshop"],
        ["name" : "Chicken Wings", "code": "chicken_wings"],
        ["name" : "Chilean", "code": "chilean"],
        ["name" : "Chinese", "code": "chinese"],
        ["name" : "Comfort Food", "code": "comfortfood"],
        ["name" : "Corsican", "code": "corsican"],
        ["name" : "Creperies", "code": "creperies"],
        ["name" : "Cuban", "code": "cuban"],
        ["name" : "Curry Sausage", "code": "currysausage"],
        ["name" : "Cypriot", "code": "cypriot"],
        ["name" : "Czech", "code": "czech"],
        ["name" : "Czech/Slovakian", "code": "czechslovakian"],
        ["name" : "Danish", "code": "danish"],
        ["name" : "Delis", "code": "delis"],
        ["name" : "Diners", "code": "diners"],
        ["name" : "Dumplings", "code": "dumplings"],
        ["name" : "Eastern European", "code": "eastern_european"],
        ["name" : "Ethiopian", "code": "ethiopian"],
        ["name" : "Fast Food", "code": "hotdogs"],
        ["name" : "Filipino", "code": "filipino"],
        ["name" : "Fish & Chips", "code": "fishnchips"],
        ["name" : "Fondue", "code": "fondue"],
        ["name" : "Food Court", "code": "food_court"],
        ["name" : "Food Stands", "code": "foodstands"],
        ["name" : "French", "code": "french"],
        ["name" : "French Southwest", "code": "sud_ouest"],
        ["name" : "Galician", "code": "galician"],
        ["name" : "Gastropubs", "code": "gastropubs"],
        ["name" : "Georgian", "code": "georgian"],
        ["name" : "German", "code": "german"],
        ["name" : "Giblets", "code": "giblets"],
        ["name" : "Gluten-Free", "code": "gluten_free"],
        ["name" : "Greek", "code": "greek"],
        ["name" : "Halal", "code": "halal"],
        ["name" : "Hawaiian", "code": "hawaiian"],
        ["name" : "Heuriger", "code": "heuriger"],
        ["name" : "Himalayan/Nepalese", "code": "himalayan"],
        ["name" : "Hong Kong Style Cafe", "code": "hkcafe"],
        ["name" : "Hot Dogs", "code": "hotdog"],
        ["name" : "Hot Pot", "code": "hotpot"],
        ["name" : "Hungarian", "code": "hungarian"],
        ["name" : "Iberian", "code": "iberian"],
        ["name" : "Indian", "code": "indpak"],
        ["name" : "Indonesian", "code": "indonesian"],
        ["name" : "International", "code": "international"],
        ["name" : "Irish", "code": "irish"],
        ["name" : "Island Pub", "code": "island_pub"],
        ["name" : "Israeli", "code": "israeli"],
        ["name" : "Italian", "code": "italian"],
        ["name" : "Japanese", "code": "japanese"],
        ["name" : "Jewish", "code": "jewish"],
        ["name" : "Kebab", "code": "kebab"],
        ["name" : "Korean", "code": "korean"],
        ["name" : "Kosher", "code": "kosher"],
        ["name" : "Kurdish", "code": "kurdish"],
        ["name" : "Laos", "code": "laos"],
        ["name" : "Laotian", "code": "laotian"],
        ["name" : "Latin American", "code": "latin"],
        ["name" : "Live/Raw Food", "code": "raw_food"],
        ["name" : "Lyonnais", "code": "lyonnais"],
        ["name" : "Malaysian", "code": "malaysian"],
        ["name" : "Meatballs", "code": "meatballs"],
        ["name" : "Mediterranean", "code": "mediterranean"],
        ["name" : "Mexican", "code": "mexican"],
        ["name" : "Middle Eastern", "code": "mideastern"],
        ["name" : "Milk Bars", "code": "milkbars"],
        ["name" : "Modern Australian", "code": "modern_australian"],
        ["name" : "Modern European", "code": "modern_european"],
        ["name" : "Mongolian", "code": "mongolian"],
        ["name" : "Moroccan", "code": "moroccan"],
        ["name" : "New Zealand", "code": "newzealand"],
        ["name" : "Night Food", "code": "nightfood"],
        ["name" : "Norcinerie", "code": "norcinerie"],
        ["name" : "Open Sandwiches", "code": "opensandwiches"],
        ["name" : "Oriental", "code": "oriental"],
        ["name" : "Pakistani", "code": "pakistani"],
        ["name" : "Parent Cafes", "code": "eltern_cafes"],
        ["name" : "Parma", "code": "parma"],
        ["name" : "Persian/Iranian", "code": "persian"],
        ["name" : "Peruvian", "code": "peruvian"],
        ["name" : "Pita", "code": "pita"],
        ["name" : "Pizza", "code": "pizza"],
        ["name" : "Polish", "code": "polish"],
        ["name" : "Portuguese", "code": "portuguese"],
        ["name" : "Potatoes", "code": "potatoes"],
        ["name" : "Poutineries", "code": "poutineries"],
        ["name" : "Pub Food", "code": "pubfood"],
        ["name" : "Rice", "code": "riceshop"],
        ["name" : "Romanian", "code": "romanian"],
        ["name" : "Rotisserie Chicken", "code": "rotisserie_chicken"],
        ["name" : "Rumanian", "code": "rumanian"],
        ["name" : "Russian", "code": "russian"],
        ["name" : "Salad", "code": "salad"],
        ["name" : "Sandwiches", "code": "sandwiches"],
        ["name" : "Scandinavian", "code": "scandinavian"],
        ["name" : "Scottish", "code": "scottish"],
        ["name" : "Seafood", "code": "seafood"],
        ["name" : "Serbo Croatian", "code": "serbocroatian"],
        ["name" : "Signature Cuisine", "code": "signature_cuisine"],
        ["name" : "Singaporean", "code": "singaporean"],
        ["name" : "Slovakian", "code": "slovakian"],
        ["name" : "Soul Food", "code": "soulfood"],
        ["name" : "Soup", "code": "soup"],
        ["name" : "Southern", "code": "southern"],
        ["name" : "Spanish", "code": "spanish"],
        ["name" : "Steakhouses", "code": "steak"],
        ["name" : "Sushi Bars", "code": "sushi"],
        ["name" : "Swabian", "code": "swabian"],
        ["name" : "Swedish", "code": "swedish"],
        ["name" : "Swiss Food", "code": "swissfood"],
        ["name" : "Tabernas", "code": "tabernas"],
        ["name" : "Taiwanese", "code": "taiwanese"],
        ["name" : "Tapas Bars", "code": "tapas"],
        ["name" : "Tapas/Small Plates", "code": "tapasmallplates"],
        ["name" : "Tex-Mex", "code": "tex-mex"],
        ["name" : "Thai", "code": "thai"],
        ["name" : "Traditional Norwegian", "code": "norwegian"],
        ["name" : "Traditional Swedish", "code": "traditional_swedish"],
        ["name" : "Trattorie", "code": "trattorie"],
        ["name" : "Turkish", "code": "turkish"],
        ["name" : "Ukrainian", "code": "ukrainian"],
        ["name" : "Uzbek", "code": "uzbek"],
        ["name" : "Vegan", "code": "vegan"],
        ["name" : "Vegetarian", "code": "vegetarian"],
        ["name" : "Venison", "code": "venison"],
        ["name" : "Vietnamese", "code": "vietnamese"],
        ["name" : "Wok", "code": "wok"],
        ["name" : "Wraps", "code": "wraps"],
        ["name" : "Yugoslav", "code": "yugoslav"]]
        
} // func yelpCategories
}
