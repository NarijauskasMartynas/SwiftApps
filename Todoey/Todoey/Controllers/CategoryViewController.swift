//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Martynq on 19/10/2019.
//  Copyright © 2019 Martynas Narijauskas. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    var categoryArray : Results<CategoryItem>?
    
    let realm = try! Realm()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)

        cell.textLabel?.text = categoryArray?[indexPath.row].title ?? ""

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItemsView", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alertController = UIAlertController(title: "add new category", message: "", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = CategoryItem()
            
            newCategory.title = textField.text!
            
            self.saveCategory(category: newCategory)
            
        }
        
        alertController.addTextField { (alertTextField) in
            textField = alertTextField
        }
        
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
    }
    func loadCategories(){
        categoryArray = realm.objects(CategoryItem.self)
        
        tableView.reloadData()
    }
    
    func saveCategory(category : CategoryItem){
        do{
            try realm.write {
                realm.add(category)
            }
        }
        catch{
            print("error saving category")
        }
        
        tableView.reloadData()
    }


}
