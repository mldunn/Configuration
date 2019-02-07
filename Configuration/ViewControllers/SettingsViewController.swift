//
//  SettingsViewController.swift
//  Configuration
//
//  Created by michael dunn on 2/6/19.
//  Copyright © 2019 michael dunn. All rights reserved.
//

import UIKit
import CoreData


class SettingsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBAction func doneTapped(_ sender: Any) {
        if isDirty {
            displayAlert()
        }
        else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        saveContext()
    }
    
    var isDirty: Bool = false {
        didSet {
            saveButton.isEnabled = isDirty
        }
    }
    
    
    var isXmlParsed: Bool {
        get {
            let val = UserDefaults.standard.bool(forKey: "isXmlParsed")
            LogService.log("isXmlParsed: \(val)")
            return val
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isXmlParsed")
            UserDefaults.standard.synchronize()
        }
    }
    
    var managedContext: NSManagedObjectContext?
  
    var dataItems: [Section]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        managedContext = appDelegate.persistentContainer.viewContext
        
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        if isXmlParsed {
            loadItems()
        }
        else {
            loadXML()
        }
    }
    
    func loadXML() {
        
        DispatchQueue.global().async {
            let sections = SectionTag.allCases.map { $0 }
            let parser = ParserService(name: "configuration", root: "configuration", tags: sections)
            parser.parse { [weak self] (success, error) in
               
                self?.saveXML(parser.xmlElements)
            }
        }
    }
   
    func saveXML(_ xmlData: [XMLSection]) {
        DispatchQueue.global().async { [weak self] in
            if let context = self?.managedContext {
            DataModelService.saveConfiguration(xmlData, managedContext: context)
                self?.isXmlParsed = true
                self?.loadItems()
            }
        }
        
    }
    
    func loadItems() {
        if let context = managedContext {
            dataItems = DataModelService.getSections(managedContext: context)
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
                self?.dumpItems()
            }
        }
    }
    
    func dumpItems() {
        for section in dataItems ?? [] {
           for item in section.items ?? [] {
                if let item = item as? SectionItem {
                    print(item.details)
                }
            }
        }
    }

    func saveContext() {
        
        dumpItems()
        do {
           try  managedContext?.save()
        }
        catch {
            
        }
        isDirty = false
        
    }
    
    // MARK: - Alert
    
    func displayAlert() {
       
        let alertTitle = NSLocalizedString("ALERT_TITLE", comment: "alertTitle")
        let alertMessage = NSLocalizedString("ALERT_MESSAGE", comment: "alertTitle")
        let alertDoneAction = NSLocalizedString("ALERT_DONE_ACTION", comment: "alertTitle")
        let alertSaveAction = NSLocalizedString("ALERT_SAVE_ACTION", comment: "alertTitle")
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: alertDoneAction, style: .default, handler: { [weak self] action in
            self?.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: alertSaveAction, style: .default, handler: { [weak self] action in
            self?.saveContext()
        }))
    
        present(alert, animated: true, completion: nil)
    }
   
}


// MARK: - TableView Delegate and DataSource

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let xs = dataItems?[section] {
            return xs.itemCount
        }
        return  0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let xs = dataItems?[indexPath.section], let item = xs.items?.allObjects[indexPath.row] as? SectionItem, let dataType = item.dataType, let type = ItemType(rawValue: dataType) {
         
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: type.cellIdentifier, for: indexPath) as? ItemTableViewCell {
                  cell.configure(item: item)
                  cell.changeDelegate = self
                 return cell
            }
        }
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = SectionHeaderView()
        if let xs = dataItems?[section] {
            view.configure(id: xs.id, name: xs.name) 
        }
        return view
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
   
}

extension SettingsViewController: ItemTableViewCellDelegate {
    func valueDidChange() {
        isDirty = true
    }
}

