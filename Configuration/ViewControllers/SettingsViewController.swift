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
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    @IBAction func doneTapped(_ sender: Any) {
        if isDirty {
            displaySaveAlert()
        }
        else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        saveContext()
    }
    
    private var managedContext: NSManagedObjectContext?
    private var configuration: [Section]?
    private var workerQueue = DispatchQueue(label: "configration.worker")
    
    private var isDirty: Bool = false {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        saveButton.tintColor = UIColor.customBlue
        doneButton.tintColor = UIColor.customBlue
        
        managedContext = appDelegate.persistentContainer.viewContext
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
       
        // NSManagedObjectContextObjectsDidChangeNotification
    
        NotificationCenter.default.addObserver(self, selector: #selector(managedObjectContextChanged), name: Notification.Name.NSManagedObjectContextObjectsDidChange, object: managedContext)
        
        if isXmlParsed {
            loadItems()
        }
        else {
            loadXML()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: keyboard support

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        tableView.contentInset = UIEdgeInsets.zero
    }

    // MARK: XML Helpers
    
    func loadXML() {
        workerQueue.async {
            
            let parser = ParserService(name: "configuration")
            parser.parse { [weak self] (success, error) in
                
                if let error = error {
                   LogService.error(error, message: "loadXML FAILED")
                }
                else {
                    self?.saveXML(parser.xmlElements)
                }
            }
        }
    }
    
    func saveXML(_ xmlData: [XMLSection]) {
        workerQueue.async { [weak self] in
            
            guard let sSelf = self else { return }
            
            if let context = sSelf.managedContext {
                DataModelService.saveConfiguration(xmlData, managedContext: context)
                sSelf.isXmlParsed = true
                sSelf.loadItems()
            }
        }
    }
    
    // MARK: Core Data Support
    
    @objc func managedObjectContextChanged(_ notification: Notification) {
        LogService.log("managedObjectContextChanged")
        isDirty = true
    }
    
    func loadItems() {
        if let context = managedContext {
            configuration = DataModelService.getConfiguration(managedContext: context)
            DispatchQueue.main.async { [weak self] in
                self?.isDirty = false
                self?.tableView.reloadData()
            }
        }
    }
    
    func saveContext() {
        
        managedContext?.perform() {
            do {
                try self.managedContext?.save()
            }
            catch let error as NSError {
                LogService.error(error, message: "Save Context FAILED")
            }
        }
//        
//        // save using a background thread
//        DispatchQueue.global().async { [weak self] in
//            
//            guard let sSelf = self else { return }
//            
//            do {
//                try sSelf.managedContext?.save()
//            }
//            catch let error as NSError {
//                LogService.error(error, message: "Save Context FAILED")
//            }
//        }
        isDirty = false
    }
    
    func discardContext() {
        managedContext?.rollback()
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Alert Controller
    
    func displaySaveAlert() {
        
        let alertTitle = NSLocalizedString("ALERT_TITLE", comment: "alertTitle")
        let alertMessage = NSLocalizedString("ALERT_MESSAGE", comment: "alertTitle")
        let alertDoneAction = NSLocalizedString("ALERT_DONE_ACTION", comment: "alertTitle")
        let alertSaveAction = NSLocalizedString("ALERT_SAVE_ACTION", comment: "alertTitle")
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: alertDoneAction, style: .default, handler: { [weak self] action in
            self?.discardContext()
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
        if let xs = configuration?[section] {
            return xs.itemCount
        }
        return  0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let xs = configuration?[indexPath.section] {
            let item = xs.sectionItems[indexPath.row]
            if let dataType = item.dataType,
                let type = ItemType(rawValue: dataType),
                let cell = tableView.dequeueReusableCell(withIdentifier: type.cellIdentifier, for: indexPath) as? ItemTableViewCell {
                cell.configure(item: item)
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return configuration?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerView = Bundle.main.loadNibNamed("SectionHeaderView", owner: nil, options: nil)?.first as? SectionHeaderView,
            let xs = configuration?[section] {
            headerView.configure(id: xs.id, name: xs.name)
        
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

