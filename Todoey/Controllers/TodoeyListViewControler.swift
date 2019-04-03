//
//  ViewController.swift
//  Todoey
//
//  Created by Marcos Peres on 25.03.19.
//  Copyright © 2019 Marcos Martins. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoeyListViewController: SwipeTableViewController {
    
    var toDoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
           loadItems()
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        
        tableView.rowHeight = 80.0
        
    }
    
    @IBOutlet weak var searchItems: UISearchBar!
    
    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedCategory!.name

        if let colorHex = selectedCategory?.color {
            
            updateNavBar(withHexCode: colorHex)
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        updateNavBar(withHexCode: "1D9BF6")
        
    }
    
    //MARK: = Navigation Bar Setup Methods
    
    func updateNavBar (withHexCode colorCode: String) {
        
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controler does not exist")}
        
        guard let navBarColor = UIColor(hexString: colorCode) else {fatalError()}
        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        searchItems.barTintColor = navBarColor
        
    }
    
    //MARK: - Tableview Datasources Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return toDoItems?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let categoryColor = UIColor(hexString: self.selectedCategory!.color)
        
        if let item = toDoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            if let color = categoryColor?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(toDoItems!.count)) {
            
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
                
            }
            
            cell.accessoryType = item.done ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No items"
        }

        return cell
        
    }
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                item.done = !item.done
                }
            } catch {
                print("Error saving done, \(error)")
            }
            
        }
        
        self.tableView.reloadData()
    }

    //MARK: - Add new items
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a new item", message: "", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add item", style: .default) { (action) in
            //Append new items in the array
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCaptured = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving item \(error)")
                }

            }
            
            self.tableView.reloadData()

        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new item"
            textField = alertTextField
        }
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Model Manioulation Methods
    
    func loadItems() {

        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()

    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemToBeDeleted = self.toDoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemToBeDeleted)
                }
            } catch {
                print("Error saving done, \(error)")
            }
        }
    }
    
}

// MARK: - Search Bar Methods

extension TodoeyListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCaptured", ascending: true)
        
        tableView.reloadData()

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }

}
