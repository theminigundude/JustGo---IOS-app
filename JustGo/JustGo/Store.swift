//
//  Store.swift
//  JustGo
//
//  Created by Ronan Chang on 2019/5/3.
//  Copyright © 2019 ios.nyu.edu. All rights reserved.
//

import UIKit


class Store: NSObject {
    var name:String = "No Name"
    var storeID = "No Id"
    var drinks = [Item]()
    var food = [Item]()
    var address:String = "No addr."
    var lat:String = ""
    var lon:String = ""
    
    init(name:String, storeID:String, drinks:[Item],food:[Item],address:String,lat:String,lon:String){
        self.name = name
        self.storeID = storeID
        self.drinks = drinks
        self.food = food
        self.address = address
        self.lat = lat
        self.lon = lon
        
    }
    
    func getInfo(){
        print("Store name: \(self.name) \n Address:\(self.address) \n Drinks:\(self.drinks.count) \n Food:\(self.food.count) \n Lat and lon: \(self.lat, self.lon) \n")
    }

}
