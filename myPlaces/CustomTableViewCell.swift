//
//  CustomTableViewCell.swift
//  myPlaces
//
//  Created by Роман on 15.11.2020.
//

import UIKit
import Cosmos

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var typeLable: UILabel!
    @IBOutlet weak var imageOfPlace: UIImageView!{
        didSet{
            imageOfPlace.layer.cornerRadius = imageOfPlace.frame.size.height / 2
            imageOfPlace.clipsToBounds = true
        }
    }
    @IBOutlet weak var locationLable: UILabel!
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet var cosmosView: CosmosView! {
        didSet {
            cosmosView.settings.updateOnTouch = false
        }
    }
}
