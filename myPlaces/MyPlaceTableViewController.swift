//
//  MyPlaceTableViewController.swift
//  myPlaces
//
//  Created by Роман on 11.11.2020.
//

import UIKit
import RealmSwift

class MyPlaceTableViewController: UIViewController, UITableViewDataSource, UITabBarDelegate {
    

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControll: UISegmentedControl!
    @IBOutlet weak var reversedSortinButton: UIBarButtonItem!
    
    var places: Results<Place>!
    var ascendingSorting = true

    override func viewDidLoad() {
        super.viewDidLoad()
        places = realm.objects(Place.self)

      
    }

    // MARK: - Table view data source



     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return places.isEmpty ? 0 : places.count
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        let place = places[indexPath.row]
        
        
        cell.nameLable.text = place.name
        cell.locationLable.text = place.location
        cell.typeLable.text = place.type
        cell.imageOfPlace.image = UIImage(data: place.imageData!)

        cell.imageOfPlace.layer.cornerRadius = cell.imageOfPlace.frame.size.height / 2
        cell.imageOfPlace.clipsToBounds = true



        return cell
    }
    
//    MARK: Table veiw delegate
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let place = places[indexPath.row]
       
        let deliteAction = UIContextualAction(style: .destructive, title: "Удалить") { (_ , _, _) in
            
            StoregeMagager.deliteObject(place)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
        let swipe = UISwipeActionsConfiguration(actions: [deliteAction])
        return swipe
    } 

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ==  "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let place = places[indexPath.row]
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
