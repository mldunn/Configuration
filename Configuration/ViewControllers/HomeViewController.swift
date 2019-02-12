//
//  HomeViewController.swift
//  Configuration
//
//  Created by michael dunn on 2/6/19.
//  Copyright © 2019 michael dunn. All rights reserved.
//

import UIKit



class HomeViewController: UIViewController {

    @IBOutlet weak var editSettingsButton: UIButton!
    @IBOutlet weak var bundleVersionLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Grab the bundle version number to display to the home screen
        
        if let bundleVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            
            let localizedString = NSLocalizedString("BUNDLE_VERSION", comment: "bundle version")
            let formattedString = String(format: localizedString, bundleVersion)

            bundleVersionLabel.text = formattedString
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        LogService.log("prepare for segue \(String(describing: segue.identifier))")
        var editType: EditType?
        switch segue.identifier {
        case EditType.email.segueIdentifier:
            editType = EditType.email
        case EditType.configuration.segueIdentifier:
            editType = EditType.configuration
        default:
            break
        }
        
        if let navController = segue.destination as? UINavigationController, let settingsViewController = navController.topViewController as? SettingsViewController {
            if let editType = editType {
                settingsViewController.editType = editType
            }
        }
        
    }
}
