//
//  ViewController.swift
//  Todoey
//
//  Created by Martynas Narijauskas on 10/4/19.
//  Copyright © 2019 Martynas Narijauskas. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [TodoItem]()
    
    var selectedCategory : CategoryItem?{
        didSet{
            loadItems()
        }
    }
    
    let docsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellItem", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].itemName
        
        let item = itemArray[indexPath.row]
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let item = itemArray[indexPath.row]
        item.done = !item.done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func AddItemPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()

        let alert = UIAlertController(title: "Add new task todo!", message: "", preferredStyle: .alert)

        let alertAction = UIAlertAction(title: "Add new item", style: .default) { (alertAction) in
            
            let item = TodoItem(context: self.context)
            
            item.itemName = textField.text!
            item.done = false
            item.parentCategory = self.selectedCategory
            self.itemArray.append(item)
            self.saveItems()
        }

        alert.addTextField { (alertTextField) in
            textField = alertTextField
        }
        
        alert.addAction(alertAction)

        present(alert, animated: true, completion: nil)
    }
    
    func saveItems(){
        do{
            try context.save()
        }
        catch{
            print("Whoops \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadItems(fetchString : String = ""){

        let request : NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        
        let categoryPredicate = NSPredicate(format: "parentCategory.title MATCHES[cd] %@", selectedCategory!.title!)
        
        if fetchString != ""{
            
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, NSPredicate(format: "itemName CONTAINS[cd] %@", fetchString)])
            request.predicate = compoundPredicate
            
            request.sortDescriptors = [NSSortDescriptor(key: "itemName", ascending: true)]
        }
        else{
            request.predicate = categoryPredicate
        }
        
        do{
            itemArray = try context.fetch(request)
        }
        catch{
            print("error: \(error)")
        }
        
        tableView.reloadData()
        
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
            loadItems(fetchString: searchBar.text!)
        }
    }
    
}
