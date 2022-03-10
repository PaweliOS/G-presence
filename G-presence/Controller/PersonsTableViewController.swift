//
//  PersonsTableViewController.swift
//  G-presence
//
//  Created by Paweł on 06/03/2022.
//

import UIKit
import CoreData

class PersonsTableViewController: UITableViewController {
    
    var personList = [Person]()
    var selectedGroup : Group? {
        didSet {
            loadPerson()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

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
        return personList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath)
        let personCell = personList[indexPath.row]
        cell.textLabel?.text = personCell.name
        
        cell.accessoryType = personCell.presence ? .checkmark : .none
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        personList[indexPath.row].presence = !personList[indexPath.row].presence//zapis do tabeli na tak jeśli nie i na nie jeśli tak
        savePerson() //zapis context'u
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true) // animacja odznaczenia
    }
    
 
//   MARK: - Persons modifying
    
    @IBAction func addPersonButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let allert = UIAlertController(title: "Add new person", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add person", style: .default) { action in
            let newPerson = Person(context: self.context)
            newPerson.name = textField.text!
            // ustawiam własności obiektu tabeli Person:
            newPerson.presence = false
            newPerson.parentGroup = self.selectedGroup  //wskazujesz obiekt klasy Group (w bazie)
            
            self.personList.append(newPerson)
            self.savePerson()
            self.tableView.reloadData()
        }
        allert.addTextField { allertTextField in
            allertTextField.placeholder = "Create new person"
            textField = allertTextField
        }
        
        allert.addAction(action)
        present(allert, animated: true, completion: nil)
        
    }
    
    
    
    
// MARK: - Data manipulation methods
    
    func loadPerson(with request: NSFetchRequest<Person> = Person.fetchRequest(), predicate: NSPredicate? = nil ){
        
        let groupPredicate = NSPredicate(format: "parentGroup.name MATCHES %@", selectedGroup!.name!)
        request.predicate = groupPredicate
        
        do {
            personList = try context.fetch(request)
        } catch {
            print("Error fetching Person data from context \(error)")
        }
        tableView.reloadData()
    }
    
    func savePerson() {
        
        do {
        try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        tableView.reloadData()
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
