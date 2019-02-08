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
    
    

    private var managedContext: NSManagedObjectContext?
    private var configuration: [Section]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        managedContext = appDelegate.persistentContainer.viewContext
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    
    
        if isXmlParsed {
            loadItems()
        }
        else {
            loadXML()
        }
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
        DispatchQueue.global().async {
            
            let parser = ParserService(name: "configuration")
            parser.parse { [weak self] (success, error) in
                
                self?.saveXML(parser.xmlElements)
            }
        }
    }
    
    func saveXML(_ xmlData: [XMLSection]) {
        DispatchQueue.global().async { [weak self] in
            
            guard let sSelf = self else { return }
            
            if let context = sSelf.managedContext {
                DataModelService.saveConfiguration(xmlData, managedContext: context)
                sSelf.isXmlParsed = true
                sSelf.loadItems()
            }
        }
        
    }
    
    // MARK: Load Items
    
    func loadItems() {
        if let context = managedContext {
            configuration = DataModelService.getConfiguration(managedContext: context)
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    func saveContext() {
        // save using a background thread
        
        DispatchQueue.global().async { [weak self] in
            
            guard let sSelf = self else { return }
            
            do {
                try  sSelf.managedContext?.save()
            }
            catch {
                
            }
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
                cell.changeDelegate = self
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return configuration?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = SectionHeaderView()
        if let xs = configuration?[section] {
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

