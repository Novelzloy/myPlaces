//
//  StoragManager.swift
//  myPlaces
//
//  Created by Роман on 23.11.2020.
//
    
import RealmSwift

let realm = try! Realm()

class StoregeMagager {
    
    static func saveObject (_ place: Place) {
        try! realm.write {
            realm.add(place)
        }
    }
}
