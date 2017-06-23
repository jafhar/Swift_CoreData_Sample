//
//  TDViewController.swift
//  TrainingDetails-CoreData
//
//  Created by  on 23/06/17.
//  Copyright © 2017 jafhar. All rights reserved.
//

import UIKit
import CoreData

class TDViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var trainingNames: [NSManagedObject] = []
    
    @IBAction func addTrainingName(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: TDConstants.kTDAlertTitle,
                                      message: TDConstants.kTDAlertMessage,
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: TDConstants.kTDSaveActionTitle,
                                       style: .default) {
                                        [unowned self] action in
                                        
                                        guard let textField = alert.textFields?.first,
                                            let nameToSave = textField.text else {
                                                return
                                        }
                                        
                                        self.save(name: nameToSave)
                                        self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: TDConstants.kTDCancelTitle,
                                         style: .default)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = TDConstants.kTDNavigationBarTitle
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: TDConstants.kTDTableViewCellIdentifier)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: TDConstants.kTDEntityName)
        
        do {
            trainingNames = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("\(TDConstants.kTDDataFetchFailureMessage), \(error.localizedDescription), \(error.userInfo)")
        }
    }
    
    
    private func save(name: String) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entity =
            NSEntityDescription.entity(forEntityName: TDConstants.kTDEntityName,
                                       in: managedContext)!
        
        let subject = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        subject.setValue(name, forKeyPath: TDConstants.kTDAttributeName)
        
        do {
            try managedContext.save()
            trainingNames.append(subject)
        } catch let error as NSError {
            print("\(TDConstants.kTDSaveFailureMessage), \(error.localizedDescription), \(error.userInfo)")
        }
    }

}


// MARK: - UITableViewDataSource
extension TDViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return trainingNames.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            
            let trainingSubject = trainingNames[indexPath.row]
            let cell =
                tableView.dequeueReusableCell(withIdentifier: TDConstants.kTDTableViewCellIdentifier,
                                              for: indexPath)
            cell.textLabel?.text = trainingSubject.value(forKeyPath: TDConstants.kTDAttributeName) as? String
            return cell
    }
}
