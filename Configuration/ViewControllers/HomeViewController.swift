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

        // Do any additional setup after loading the view.
        
        if let bundleVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            
            let localizedString = NSLocalizedString("BUNDLE_VERSION", comment: "bundle version")
            let formattedString = String(format: localizedString, bundleVersion)

            bundleVersionLabel.text = formattedString
        }
        
        editSettingsButton.setTitleColor(UIColor.customBlue, for: .normal)
        
    }
    

}
