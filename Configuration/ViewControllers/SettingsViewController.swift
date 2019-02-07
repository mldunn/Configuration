//
//  SettingsViewController.swift
//  Configuration
//
//  Created by michael dunn on 2/6/19.
//  Copyright © 2019 michael dunn. All rights reserved.
//

import UIKit

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
    
    var isDirty: Bool = false {
        didSet {
            saveButton.isEnabled = isDirty
        }
    }
    
    
    var isXmlParsed: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "isXmlParsed")
        }
        set {
            UserDefaults.standard.set(isXmlParsed, forKey: "isXmlParsed")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        let sections = Sections.allCases.map { $0.rawValue }
        let parser = ParserService(name: "configuration", root: "configuration", tags: sections)
        parser.parse { [weak self] (success, error) in
            // firstLaunch = true
            self?.loadItems()
        }
    }
   
    
    func loadItems() {
        
        for section in sections {
            items[section.name] = []
            
            var index = 0
            let item = Item(key: "key\(index)", type: types[index], boolValue: false, numValue: index+2, stringValue: "string\(index)", id:   nil)
            items[section.name]?.append(item)
            
            index += 1
            let item2 = Item(key: "key\(index)", type: types[index], boolValue: false, numValue: index+2, stringValue: "string\(index)", id:   nil)
            items[section.name]?.append(item2)
            
            index += 1
            let item3 = Item(key: "key\(index+2)", type: types[index], boolValue: false, numValue: index+2, stringValue: "string\(index)", id:   nil)
            
            items[section.name]?.append(item3)
        }
        
        tableView.reloadData()
    }

    
    func displayAlert() {
       
        let title = "Alert"
        let message = "You have unsaved data.  Save Changes?"
        let discard = "Discard"
        let OK = "Save"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: discard, style: .default, handler: { [weak self] action in
        
            self?.dismiss(animated: true, completion: nil)
            
        }))
        
        alert.addAction(UIAlertAction(title: OK, style: .default, handler: { action in
            
            
        }))
    
        present(alert, animated: true, completion: nil)
    }
   
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[sections[section].name]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        if let item = items[section.name]?[indexPath.row],
            let cell = tableView.dequeueReusableCell(withIdentifier: item.type.cellIdentifier, for: indexPath) as? ItemTableViewCell {
            cell.configure(item: item)
            cell.changeDelegate = self
            return cell 
        }
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let item = sections[section]
        let view = SectionHeaderView()
        view.configure(id: item.id, name: item.name)
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

