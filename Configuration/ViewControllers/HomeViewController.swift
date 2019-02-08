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
        
        // Add a little color to the Edit Button
        
        editSettingsButton.setTitleColor(UIColor.customBlue, for: .normal)
    }
    

}
