//
//  MyPlaceTableViewController.swift
//  myPlaces
//
//  Created by Роман on 11.11.2020.
//

import UIKit
import RealmSwift

class MyPlaceTableViewController: UIViewController, UITableViewDataSource, UITabBarDelegate {
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var filterResult: Results<Place>?
    private var places: Results<Place>!
    private var ascendingSorting = true
    private var searchBarIsEmpty: Bool{
        guard let text = searchController.searchBar.text else {return false}
        return text.isEmpty
    }
    
    private var isFilterActive: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControll: UISegmentedControl!
    @IBOutlet weak var reversedSortinButton: UIBarButtonItem!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        places = realm.objects(Place.self)
        
        // Set the search controller
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        self.tableView.rowHeight = UITableView.automaticDimension;

      
    }

    // MARK: - Table view data source



     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFilterActive{
            return filterResult!.count
        }
        return places.count
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        let place = isFilterActive ? filterResult![indexPath.row] : places[indexPath.row]
        
        cell.nameLable.text = place.name
        cell.locationLable.text = place.location
        cell.typeLable.text = place.type
        cell.imageOfPlace.image = UIImage(data: place.imageData!)
        cell.cosmosView.rating = place.rating

        return cell
    }
    
   // MARK: Table veiw delegate
    

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let place = places[indexPath.row]

        let deliteAction = UIContextualAction(style: .destructive, title: "Удалить") { (_, _,  complete) in

            StoregeMagager.deliteObject(place)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            complete(true)

        }

        return UISwipeActionsConfiguration(actions: [deliteAction])
    }

 //MARK: Navigaton
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ==  "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            
            let place = isFilterActive ? filterResult![indexPath.row]: places[indexPath.row]
//            if isFilterActive{
//                place = filterResult![indexPath.row]
//            } else {
//                place = places[indexPath.row]
//            }
            let newPalaceVC = segue.destination as! NewPlaceViewController
            newPalaceVC.currenPlace = place
        }
    }


    @IBAction func unwindSegue(_ segue: UIStoryboardSegue){
        guard let newPlaceVC = segue.source as? NewPlaceViewController else { return }
        newPlaceVC.savePlace()
        tableView.reloadData()
        
    }
    @IBAction func sortSelection(_ sender: UISegmentedControl) {
        sorting()
    }


    @IBAction func reversSotring(_ sender: Any) {
        ascendingSorting.toggle()

        if ascendingSorting {
            reversedSortinButton.image = #imageLiteral(resourceName: "AZ")
        } else {
            reversedSortinButton.image = #imageLiteral(resourceName: "ZA")
        }
        sorting()
    }


    private func sorting(){
        if segmentedControll.selectedSegmentIndex == 0{
            places = places.sorted(byKeyPath: "date", ascending: ascendingSorting)
        } else {
            places = places.sorted(byKeyPath: "name", ascending: ascendingSorting)
        }
        tableView.reloadData()
    }
}

extension MyPlaceTableViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filterContetntForSearchText(searchController.searchBar.text!)
    }
    private func filterContetntForSearchText (_ searchText: String){
        filterResult = places.filter("name CONTAINS[c] %@ OR location CONTAINS[c] %@", searchText, searchText)
        tableView.reloadData()
    }

}
