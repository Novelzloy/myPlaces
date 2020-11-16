//
//  NewPlaceViewController.swift
//  myPlaces
//
//  Created by Роман on 16.11.2020.
//

import UIKit

class NewPlaceViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()

        
    }
    //MARK - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
        } else{
            view.endEditing(true)
        }
    }


}
//MARK: - text field delegate

extension NewPlaceViewController: UITextFieldDelegate {
    // Скрываем клавиатуру по нажатию на DONE
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
