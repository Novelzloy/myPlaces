//
//  PlaceModel.swift
//  myPlaces
//
//  Created by Роман on 15.11.2020.
//

import RealmSwift

class Place: Object {
    @objc dynamic var name = ""
    @objc dynamic var location: String?
    @objc dynamic var imageData: Data?
    @objc dynamic var type: String?
    
    convenience init(name: String, location: String?, imageData: Data?, type: String?) {
        self.init()
        self.name = name
        self.location = location
        self.type = type
        self.imageData = imageData
    }
}
