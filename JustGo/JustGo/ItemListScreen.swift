//
//  ItemListScreen.swift
//  JustGo
//
//  Created by Ronan Chang on 2019/5/5.
//  Copyright © 2019 ios.nyu.edu. All rights reserved.
//

import UIKit
import FirebaseDatabase


var storeArr = [Store]()
var itemArr = [Item]()
var imageArr = [UIImage]()


class ItemListScreen: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    var tempStoreArr = [Store]()
    var tempItemArr = [Item]()
    
    
    
    //setup search controller
    var search_text:String = ""
    let searchController = UISearchController(searchResultsController: nil)
    
    
    //for searching results
    var filteredItems = [Item]()
    var homepageFilteredItems = [Item]()

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(search_text)
        
        //setting up searchController and navigation bar
        self.setupSearchController()
        self.setupNavBar()
        searchController.isActive = true
        searchController.searchBar.becomeFirstResponder()
        
        if !search_text.isEmpty {
            filterArray(keyword: search_text)
        }

        print("search_text is: \(search_text)")
        print("is search bar empty? \(searchBarIsEmpty())")

        
        print("program started")
        //use Firebase to load data for table
        let ref = Database.database().reference()
        ref.observe(.value, with: {(Snapshot) in
            if (Snapshot.childrenCount > 0) {
                for store in Snapshot.children.allObjects as! [DataSnapshot] {
                    let childRef = ref.child(store.key)
                    childRef.child("Food").observe(.value, with: { (Snapshot) in
                        for eachfood in Snapshot.children.allObjects as! [DataSnapshot] {
                            let foodObject = eachfood.value as? [String: AnyObject]
                            let foodName = foodObject?["name"]
                            let foodStoreID = foodObject?["store_ID"]
                            let foodPrice = foodObject?["price"]
                            let foodImage = foodObject?["image"]
                            let foodPicture = foodObject?["picture"]
                            //create a new food item and add to table
                            let new_food = Item(name:foodName as! String, price:foodPrice as! String, picture:foodPicture as! String, storeID:foodStoreID as! String, image:UIImage(named:foodImage as! String)!)
                            itemArr.append(new_food)
                            self.tableView.reloadData()
                        }
                    })
                    childRef.child("Drinks").observe(.value, with: {(Snapshot) in
                        for eachDrink in Snapshot.children.allObjects as! [DataSnapshot] {
                            let drinkObject = eachDrink.value as? [String: AnyObject]
                            let drinkName = drinkObject?["name"]
                            let drinkStoreID = drinkObject?["store_ID"]
                            let drinkPrice = drinkObject?["price"]
                            let drinkImage = drinkObject?["image"]
                            let drinkPicture = drinkObject?["picture"]
                            //create a new drink item and add to table
                            let new_drink = Item(name:drinkName as! String,price:drinkPrice as! String, picture:drinkPicture as! String, storeID:drinkStoreID as! String, image:UIImage(named:drinkImage as! String)!)
                        //  new_drink.getInfo()
                            itemArr.append(new_drink)
                        }
                    })
                    let storeObject = store.value as? [String: AnyObject]

                    let storeName = storeObject?["store_Name"]
                    let storeID = storeObject?["ID"]
                    let storeAddress = storeObject?["address"]
                    let storeLatitude = storeObject?["store_Latitude"]
                    let storeLongtitude = storeObject?["store_Longtitude"]
                    //create a new store
                    let new_store = Store(name:storeName as! String, storeID:storeID as! String,address:storeAddress as! String, lat:storeLatitude as! String,lon:storeLongtitude as! String)
                    storeArr.append(new_store)
                    self.tableView.reloadData()
                }
            }
            
            //FOR JIMMY: loop through storeArr to get the coordinates and store name
        })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                if segue.identifier == "ListToDetail"{
                    let destination = segue.destination as! DetailViewController
                    destination.item = sender as? Item
                }
            }
    //setting up search controller
    func setupSearchController(){
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Food"
        searchController.isActive = true
        searchController.searchBar.text = search_text
        definesPresentationContext = true
    }
    
    //setting up navigation bar
    func setupNavBar(){
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    //implement searching
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredItems = itemArr.filter({( item : Item) -> Bool in
            return item.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }

    func filterArray(keyword:String){
        filteredItems = itemArr.filter({( item : Item) -> Bool in
            return item.name.lowercased().contains(keyword.lowercased())
        })
        tableView.reloadData()
    }
}

extension ItemListScreen: UITableViewDataSource, UITableViewDelegate{
    //update searching
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredItems.count
        }
        return itemArr.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        let item: Item
        if ( isFiltering()) {
            item = filteredItems[indexPath.row]
        } else {
            item = itemArr[indexPath.row]
        }
        cell.setItem(item: item)
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = itemArr[indexPath.row]
        performSegue(withIdentifier: "ListToDetail", sender: item)
    }

}

extension ItemListScreen: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
