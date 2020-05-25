//
//  ChooseCountryPopUpViewController.swift
//  QuarantineApp
//
//  Created by Oliver Kramer on 23/05/2020.
//  Copyright © 2020 Oliver Kramer. All rights reserved.
//

import UIKit

class ChooseCountryPopUpViewController: UITableViewController, UISearchResultsUpdating {
    
    
    var queryServiceAPI = QueryServiceAPI()
    var parentVC: SummaryViewController?
    
    var countriesAvailable = [CountrySlug]()
    var filteredCountries = [CountrySlug]()
    
    var searchBar = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBarSetup()
        
        // get the countries which are available, sorts them in ascending order and finally reloads the tableview data
        queryServiceAPI.getCountriesAvailable { (countriesAvailable) in
            
            self.countriesAvailable = countriesAvailable.sorted{($0.country < $1.country)}
                        
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
    
    func searchBarSetup(){
        searchBar = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.placeholder = "Search for country"
            tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBar.isActive{
            return filteredCountries.count
        }else{
            return countriesAvailable.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if searchBar.isActive {
            cell.textLabel?.text = filteredCountries[indexPath.row].country
        }else{
            cell.textLabel?.text = countriesAvailable[indexPath.row].country
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let countryChosen: CountrySlug
        
        if searchBar.isActive{
            countryChosen = filteredCountries[indexPath.row]
            dismiss(animated: true, completion: nil)
        }else{
            countryChosen = countriesAvailable[indexPath.row]
        }
        
        parentVC?.handleCountryChosen(country: countryChosen)
        print(countryChosen.country)
        dismiss(animated: true, completion: nil)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredCountries.removeAll(keepingCapacity: false)
        
        filteredCountries = countriesAvailable.filter { (CountrySlug) -> Bool in
            return CountrySlug.country.lowercased().contains(searchController.searchBar.text!.lowercased())
        }
        
        self.tableView.reloadData()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
