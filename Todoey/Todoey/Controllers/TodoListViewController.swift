//
//  ViewController.swift
//  Todoey
//
//  Created by Martynas Narijauskas on 10/4/19.
//  Copyright © 2019 Martynas Narijauskas. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeableCellViewController {

    var itemArray : Results<TodoItem>?
    
    var selectedCategory : CategoryItem?{
        didSet{
            loadItems()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
    }

    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory!.title
        searchBar.barTintColor = UIColor(hexString: selectedCategory!.colorHex)
        
        if let navBar = navigationController?.navigationBar{
            navBar.tintColor = FlatBlack()

        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let itemResults = itemArray{
            cell.textLabel?.text = itemResults[indexPath.row].itemName
            
            if let colour = UIColor(hexString: selectedCategory!.colorHex)?.darken(byPercentage:
                CGFloat(indexPath.row) / CGFloat(itemArray!.count)){
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            
            let item = itemResults[indexPath.row]
            
            cell.accessoryType = item.done ? .checkmark : .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = itemArray?[indexPath.row] {

            do {
                try self.realm.write{
                    item.done = !item.done
                }
            } catch {
                print("error updating item")
            }
            
            self.tableView.reloadData()

        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func AddItemPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()

        let alert = UIAlertController(title: "Add new task todo!", message: "", preferredStyle: .alert)

        let alertAction = UIAlertAction(title: "Add new item", style: .default) { (alertAction) in
            
            if let category = self.selectedCategory{
                do{
                    try self.realm.write {
                        let item = TodoItem()
                        item.itemName = textField.text!
                        item.dateCreated = Date()
                        category.items.append(item)
                    }
                }
                catch{
                    print("error adding item \(error)")
                }

            }
            else{
                print("category is 0")
            }
            
            self.tableView.reloadData()
        }

        alert.addTextField { (alertTextField) in
            textField = alertTextField
        }
        
        alert.addAction(alertAction)

        present(alert, animated: true, completion: nil)
    }
    
    func loadItems(fetchString : String = ""){
        itemArray = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
        
    }
    
    override func deleteElement(at row: Int) {
        if let elementToDelete = itemArray?[row]{
            do{
                try realm.write {
                    realm.delete(elementToDelete)
                }
            }
            catch{
                print("error deleting the item")
            }
        }
    }
}

extension TodoListViewController : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        loadItems(fetchString: searchBar.text!)
        
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        else{
            itemArray = itemArray?.filter("itemName CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "itemName", ascending: true)
            tableView.reloadData()
        }
    }
    
}
