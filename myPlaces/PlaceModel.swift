//
//  PlaceModel.swift
//  myPlaces
//
//  Created by Роман on 15.11.2020.
//

import Foundation

struct Place {
    var name: String
    var location: String
    var image: String
    var type: String
    
    static let restaurantNames = [
            "Burger Heroes", "Kitchen", "Bonsai", "Дастархан",
            "Индокитай", "X.O", "Балкан Гриль", "Sherlock Holmes",
            "Speak Easy", "Morris Pub", "Вкусные истории",
            "Классик", "Love&Life", "Шок", "Бочка"
        ]
    static func getPlace() -> [Place] {
        var places = [Place]()
        for place in restaurantNames {
            places.append(Place(name: place, location: "Москва", image: place, type: "Ресторан"))
        }
        
        return places
        
    }
}