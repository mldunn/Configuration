//
//  SettingsViewController.swift
//  Configuration
//
//  Created by michael dunn on 2/6/19.
//  Copyright © 2019 michael dunn. All rights reserved.
//

import UIKit
import CoreData


//
// SettingsViewController - handles loading, displaying and managing config settings
//

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
    
    // context variables
    private var mainContext: NSManagedObjectContext = CoreDataService.mainContext
    
    lazy var backgroundContext: NSManagedObjectContext = {
        return CoreDataService.backgroundContext
    }()
   
    // data object
    private var configuration: Root?
    // data type
    var editType: EditType = EditType.configuration
    
    // state variables
    private var isDirty: Bool = false {
        didSet {
            saveButton.isEnabled = isDirty
        }
    }
    
    private var parsedKey: String {
        return "isXmlParsed." + editType.rawValue
    }
    
    private var isXmlParsed: Bool {
        get {
            
            let val = UserDefaults.standard.bool(forKey: parsedKey)
            LogService.log("\(parsedKey): \(val)")
            return val
        }
        set {
            UserDefaults.standard.set(newValue, forKey: parsedKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationButtons()
        
        setupTableView()
        
        setupNotifications()
        
        setupDataSource()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Setup Helpers
    
  
    func setupDataSource() {
        if isXmlParsed {
            loadItemsFromStore()
        }
        else {
            loadXMLFromBundle()
        }
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
    
    func setupNavigationButtons() {
        saveButton.tintColor = UIColor.customBlue
        doneButton.tintColor = UIColor.customBlue
    }
    
    func setupNotifications() {
        
        // keyboard
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
       
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // NSManagedObjectContextObjectsDidChangeNotification
        
        NotificationCenter.default.addObserver(self, selector: #selector(managedObjectContextChanged), name: Notification.Name.NSManagedObjectContextObjectsDidChange, object: mainContext)
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
    
    func loadXMLFromBundle() {
        
        let xmlFile = editType.bundleFile
        
        DispatchQueue.global().async {
            
            let parser = ParserService(bundleIdentifier: xmlFile)
            parser.parse { [weak self] (success, error) in
                
                if let error = error {
                   LogService.error(error, message: "loadXMLFromBundle FAILED")
                }
                else if success, let xmlRoot = parser.xmlRoot {
                    self?.saveXMLToStore(xmlRoot)
                }
                else {
                     LogService.log("loadXMLFromBundle - missing xmlRoot")
                }
            }
        }
    }
    
    func saveXMLToStore(_ xmlRoot: XMLRoot) {
        
            
        ConfigurationService.createConfiguration(xmlRoot, managedContext: backgroundContext, completion: { [weak self] (success, error) in
            
            guard let sSelf = self else { return }
            if success {
                sSelf.isXmlParsed = true
                sSelf.loadItemsFromStore()
            
                LogService.log("saveXMLToStore - SUCCEEDED")
            }
            else if let error = error {
                LogService.error(error, message: "saveXMLToStore - FAILED")
            }
            
        })
        
    }
    
    // MARK: Core Data Support
    
    @objc func managedObjectContextChanged(_ notification: Notification) {
        
        if let updatedObjects = notification.userInfo?[NSUpdatedObjectsKey] as? Set<NSManagedObject>, let item = updatedObjects.first as? SectionItem {
        
            LogService.log("managedObjectContextChanged for \(String(describing: item.key))")
            isDirty = true
        }
    }
    
    func loadItemsFromStore() {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let sSelf = self else {
                LogService.log("loadItemsFromStore - sSelf failed")
                return
            }
          
            sSelf.configuration = ConfigurationService.getConfiguration(rootKey: sSelf.editType.rootKey, managedContext: sSelf.mainContext)
        
            sSelf.isDirty = false
            sSelf.tableView.reloadData()
        }
    }
    
    // context handlers  - save, discard
    
    func saveContext() {
        
        isDirty = false
        
        if mainContext.hasChanges {
            
            ConfigurationService.saveConfiguration(mainContext) { [weak self] (success, error) in
               
                
                self?.isDirty = !success
                if success {
                    LogService.log("saveContext - SUCCESS")
                }
                else if let error = error {
                    LogService.error(error, message: "saveContext - FAILED")
                }
            }
        }
    }
    
    func discardContext() {
        if mainContext.hasChanges {
            mainContext.rollback()
        }
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
        return configuration?.itemCount(index: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let configItem = configuration?.sectionItem(for: indexPath) {
            if let dataType = configItem.dataType,
                let type = ItemType(rawValue: dataType),
                let cell = tableView.dequeueReusableCell(withIdentifier: type.cellIdentifier, for: indexPath) as? ItemTableViewCell {
                cell.configure(item: configItem)
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return configuration?.numberOfSections ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerView = Bundle.main.loadNibNamed("SectionHeaderView", owner: nil, options: nil)?.first as? SectionHeaderView,
            let configSection = configuration?.section(for: section) {
            headerView.configure(id: configSection.id, name: configSection.key)
        
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

