//
//  GroupsTableViewController.swift
//  G-presence
//
//  Created by Paweł on 06/03/2022.
//

import UIKit
import CoreData

class GroupsTableViewController: UITableViewController {

    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var groupsList = [Group]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGroup()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
/*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
*/
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groupsList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath)
        
        let groupCell = groupsList[indexPath.row]
        
        cell.textLabel?.text = groupCell.name
        // Configure the cell...
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToPersons", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let  destinationVC = segue.destination as! PersonsTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedGroup = groupsList[indexPath.row]
        }
    }
    
    
// MARK: - Data manipulation methods
    
    func saveGroup() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadGroup(with request: NSFetchRequest<Group> = Group.fetchRequest()) {
        do {
            groupsList = try context.fetch(request)
        } catch {
            print("Error fetching Group data from context \(error)")
        }
        tableView.reloadData()
    }
    
    
// MARK: - groups modifying
    
        
    @IBAction func addGroupButtonPressed(_ sender: UIBarButtonItem) {
        print("wcisniety PLUS")
        var textField = UITextField()
        let allert = UIAlertController(title: "Add new group", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add group", style: .default) { action in
            let newGroup = Group(context: self.context)
            newGroup.name = textField.text!
            self.groupsList.append(newGroup) //ważna kolejność
            self.saveGroup()                //
            self.tableView.reloadData()
        }
        allert.addTextField { allertTextField in
            allertTextField.placeholder = "Create new Groups"
            textField = allertTextField
        }
        allert.addAction(action)
        present(allert, animated: true, completion: nil)
    }
    
    @IBAction func deleteGroupButtonPressed(_ sender: UIBarButtonItem) {
        
        
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
