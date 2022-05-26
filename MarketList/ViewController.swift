//
//  ViewController.swift
//  MarketList
//
//  Created by UNAM FCA 06 on 06/04/22.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var items : [Item] = [Item]()
    var item : Item = Item()
    var action : String = "agregar"
    
    
    @IBOutlet weak var tableViewCell: UITableView!
    @IBOutlet weak var segFilter: UISegmentedControl!
    
    @IBAction func unwindToOne (_ sender : Any){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        action = "agregar"
        tableViewCell.delegate = self
        tableViewCell.dataSource = self
    }
    override func viewDidAppear(_ animated: Bool) {
        action = "agregar"
        recoverData()
        tableViewCell.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Celda", for: indexPath) as! TableViewCell
        
        let item2 = items[indexPath.row]
        
        cell.lblItem.text = item2.item
        
        return cell
    }
    
    func recoverData(){
        let context = getContext()
        let fetchRequest : NSFetchRequest<Item> = Item.fetchRequest()
        
        do {
            items = try context.fetch(fetchRequest)
            
        } catch let error as NSError {
            print("No se pudo recuperar \(error), \(error.userInfo)")
        }
    }
    
    func getContext() -> NSManagedObjectContext{
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        item = self.items[indexPath.row]
        action = "editar"
        performSegue(withIdentifier: "seguePrincipalToEdit", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seguePrincipalToEdit"{
            if action == "editar"{
            let viewControlleradd = segue.destination as! ViewControllerAddItem
                viewControlleradd.item = item
            }
        }
    }
    
    func deleteEntityItem (item: Item){
        let context = getContext()
        context.delete(item)
        
        do {
            try context.save()
        }
        catch let error as NSError{
            print("No se pudo recuperar \(error), \(error.userInfo)")
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil)
        {(_, _, completionHandler) in
            print("a matar se ha dicho")
            let item = self.items[indexPath.row]
            self.deleteEntityItem(item: item)
            self.recoverData()
            self.tableViewCell.reloadData()
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    @IBAction func changeFilter(_ sender: UISegmentedControl) {
        var type = ""
        switch sender.selectedSegmentIndex{
        case 0:
            type = Segment.Urgent.rawValue
            break
        case 1:
            type = Segment.Regular.rawValue
            break
        case 2:
            type = Segment.Low.rawValue
            break
        default:
            break
        }
        recoverItem(type: type)
        tableViewCell.reloadData()
    }
    
    func recoverItem(type : String){
        let context = getContext()
        let fetchRequest : NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "type LIKE %@", type)
        
        if type == "*"{
            fetchRequest.predicate = NSPredicate(format: "type LIKE %@ OR type == nil", type)
        } else {
            fetchRequest.predicate = NSPredicate(format: "type LIKE %@", type)
        }
        
        do {
            items = try context.fetch(fetchRequest)
            
        } catch let error as NSError {
            print("No se pudo recuperar \(error), \(error.userInfo)")
        }
    }
}
