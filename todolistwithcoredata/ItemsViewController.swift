//
//  ViewController.swift
//  todolistwithcoredata
//
//  Created by Shuihua Zhu on 27/11/18.
//  Copyright © 2018 UMA Mental Arithmetic. All rights reserved.
//

import UIKit
import CoreData
class ItemsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCategory:Category!
    @IBOutlet weak var tableView: UITableView!
    var items:[Item] = [Item]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        loadList()
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        return cell;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath)
        {
            let item = items[indexPath.row]
            item.done = !item.done
            cell.accessoryType = item.done ? .checkmark : .none
            saveList()
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
            let item = Item(context: self.context)
            item.title = textField.text!
            item.done = false
            item.time = Date()
            item.parentCategory = self.selectedCategory
            self.items.append(item)
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
        let request:NSFetchRequest<Item> = Item.fetchRequest()
        do{
            items = try context.fetch(request).filter({ (item) -> Bool in
               item.parentCategory == self.selectedCategory
            })
        }
        catch{
            print("error loading list from coredata \(error)")
        }
    }
}

