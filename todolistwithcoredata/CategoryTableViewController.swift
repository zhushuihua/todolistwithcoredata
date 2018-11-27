//
//  CategoryTableViewController.swift
//  todolistwithcoredata
//
//  Created by Shuihua Zhu on 27/11/18.
//  Copyright © 2018 UMA Mental Arithmetic. All rights reserved.
//

import UIKit
import CoreData
import SwipeCellKit
class CategoryTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categories:[Category] = [Category]()
    var selectedCategory:Category!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        loadList()
        tableView.reloadData()
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.categories.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.row]
        performSegue(withIdentifier: "goItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goItems")
        {
            let destinationVC = segue.destination as! ItemsViewController
            destinationVC.selectedCategory = selectedCategory
        }
    }
   @IBAction func addItemButtonPressed(_ sender: UIBarButtonItem) {
        var textField:UITextField!
        let alert = UIAlertController(title: "Add Item", message: nil, preferredStyle: .alert)
        alert.addTextField { (entry) in
            textField = entry
            entry.placeholder = "New Item"
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            let category = Category(context: self.context)
            category.name = textField.text!
            category.time = Date()
            self.categories.append(category)
            self.tableView.reloadData()
            self.saveList()
        }
        alert.addAction(addAction)
        present(alert, animated: true, completion: nil)
    }
    func saveList()
    {
        do{
            try context.save()
        }
        catch
        {
            print("Error saving the new item \(error)")
        }
    }
    func loadList()
    {
        let request:NSFetchRequest<Category> = Category.fetchRequest()
        do{
            categories = try context.fetch(request)
        }
        catch{
            print("error loading list from coredata \(error)")
        }
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            let category = self.categories.remove(at: indexPath.row)
            try? self.context.delete(category)
            try? self.context.save()
            // handle action by updating model with deletion
        }
        //      deleteAction.image = UIImage(named: "delete")
        return [deleteAction]
    }
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
}
