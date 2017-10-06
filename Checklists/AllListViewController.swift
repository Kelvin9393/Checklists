//
//  AllListViewController.swift
//  Checklists
//
//  Created by KELVIN LING SHENG SIANG on 24/09/2017.
//  Copyright © 2017 KELVIN LING SHENG SIANG. All rights reserved.
//

import UIKit

class AllListViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {
    
    var dataModel: DataModel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = self
        let index = dataModel.indexOfSelectedChecklist
        if index >= 0 && index < dataModel.lists.count {
            let checklist = dataModel.lists[index]
            performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = makeCell(for: tableView)
        cell.textLabel!.text = dataModel.lists[indexPath.row].name
        cell.accessoryType = .detailDisclosureButton
        cell.imageView?.image = UIImage(named: dataModel.lists[indexPath.row].iconName)
        let count = dataModel.lists[indexPath.row].countUncheckedItems()
        if dataModel.lists[indexPath.row].items.count == 0 {
            cell.detailTextLabel?.text = "(No Items)"
        } else if count == 0 {
            cell.detailTextLabel?.text = "All done"
        } else {
            cell.detailTextLabel?.text = "\(dataModel.lists[indexPath.row].countUncheckedItems()) Remaining"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataModel.indexOfSelectedChecklist = indexPath.row
        let checklist = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dataModel.lists.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let navigationController = storyboard?.instantiateViewController(withIdentifier: "ListDetailNavigationController") as! UINavigationController
        let controller = navigationController.topViewController as! ListDetailViewController
        controller.delegate = self
        let checklist = dataModel.lists[indexPath.row]
        controller.checklistToEdit = checklist
        present(navigationController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            let destinationController = segue.destination as! ChecklistViewController
            destinationController.checklist = sender as! Checklist
        } else if segue.identifier == "AddChecklist" {
            let destinationController = segue.destination.childViewControllers[0] as! ListDetailViewController
            destinationController.delegate = self
            destinationController.checklistToEdit = nil
        }
    }
    
    // create cell programmatically instead of prototype cell
    func makeCell(for tableView: UITableView) -> UITableViewCell {
        let cellIdentifier = "Cell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            return cell
        } else {
            return UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
    }

    // MARK: - listDetailViewControllerDelegate methods
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
        dataModel.lists.append(checklist)
        dataModel.sortChecklists()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
        dataModel.sortChecklists()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - navigationControllerDelegate methods
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController === self {
            dataModel.indexOfSelectedChecklist = -1
        }
    }
    

}
