//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Amarjit Singh on 12/5/18.
//  Copyright © 2018 Amarjit Singh. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var catArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    
    //MARK: TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let item = catArray[indexPath.row]
        
        cell.textLabel?.text = item.name
        
        return cell
    }
    
    //MARK: TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = catArray[indexPath.row]
        }
    }
    
    //MARK: Data Manipulation Methods
    func saveData(){
        
        do{
            try context.save()
        }
        catch{
            print("Error \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        do{
            catArray = try context.fetch(request)
        }
        catch{
            print("Error \(error)")
        }
        
        tableView.reloadData()
    }
    
    //MARK: Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add New Category"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newItem = Category(context: self.context)
            
            newItem.name = textField.text!
            if (textField.text != ""){ self.catArray.append(newItem) }
            
            self.saveData()
        }
        
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true, completion: nil)
    }
    
}
