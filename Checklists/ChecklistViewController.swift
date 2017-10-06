//
//  ViewController.swift
//  Checklists
//
//  Created by KELVIN LING SHENG SIANG on 21/09/2017.
//  Copyright © 2017 KELVIN LING SHENG SIANG. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    var checklist: Checklist!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = checklist.name
    }
    
    // MARK: - tableView methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        let item = checklist.items[indexPath.row]
        
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklist.items[indexPath.row]
            item.toggleChecked()
            configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        checklist.items.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        if editingStyle == .delete {
            tableView.deleteRows(at: indexPaths, with: .automatic)
        }
    }
    
    // MARK: - configure tableViewCell methods
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        if item.checked {
            label.text = "√"
        } else {
            label.text = ""
        }
    }
    
    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
        label.textColor = view.tintColor
    }
    
    // MARK: - addItemViewControllerDelegate methods
    func addItemViewControllerDidCancel(_ controller: ItemDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func addItemViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        dismiss(animated: true, completion: nil)
    }
    
    func addItemViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        if let index = checklist.items.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let destinationController = segue.destination.childViewControllers[0] as! ItemDetailViewController
            destinationController.delegate = self
        } else if segue.identifier == "EditItem" {
            let destinationController = segue.destination.childViewControllers[0] as! ItemDetailViewController
            destinationController.delegate = self
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                destinationController.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }

}

