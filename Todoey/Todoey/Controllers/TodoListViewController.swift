//
//  ViewController.swift
//  Todoey
//
//  Created by Martynas Narijauskas on 10/4/19.
//  Copyright © 2019 Martynas Narijauskas. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [TodoItem]()
    
    let docsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()

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
        print(itemArray[indexPath.row])
        
        let item = itemArray[indexPath.row]
        item.done = !item.done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func AddItemPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()

        let alert = UIAlertController(title: "Add new task todo!", message: "", preferredStyle: .alert)

        let alertAction = UIAlertAction(title: "Add new item", style: .default) { (alertAction) in
            let item = TodoItem()
            
            item.itemName = textField.text!
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
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: docsPath!)
        }
        catch{
            print("Whoops")
        }
        
        tableView.reloadData()
    }
    
    func loadItems(){
        
        if let data = try? Data(contentsOf: docsPath!){
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([TodoItem].self, from: data)
            }
            catch{
                print("error")
            }
        }
    }
}
