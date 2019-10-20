//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Martynq on 19/10/2019.
//  Copyright © 2019 Martynas Narijauskas. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeableCellViewController {

    var categoryArray : Results<CategoryItem>?
    
    let realm = try! Realm()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
        loadCategories()
        tableView.separatorStyle = .none

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        if let category = categoryArray?[indexPath.row]{
            
            cell.textLabel?.text = category.title
            
            guard let categoryColor = UIColor(hexString: category.colorHex) else{
                fatalError()
            }
            
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
            
            cell.backgroundColor = categoryColor
        }
        
        

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
            newCategory.colorHex = UIColor.randomFlat().hexValue()
            
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
    
    override func deleteElement(at row: Int) {
        if let categoryItem = self.categoryArray?[row]{
            do{
                try self.realm.write{
                    self.realm.delete(categoryItem)
                }
            }
            catch{
                print("error deleting the category")
            }
        }
    }


}
