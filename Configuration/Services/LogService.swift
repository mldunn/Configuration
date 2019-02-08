//
//  LogService.swift
//  Configuration
//
//  Created by michael dunn on 2/7/19.
//  Copyright © 2019 michael dunn. All rights reserved.
//

import Foundation

//
// LogService: simple console loggin service

class LogService {
    
    static func log(_ msg: String) {
        print("LOG: \(msg)")
    }
    
    static func error(_ error: NSError, message: String?) {
        if let msg = message {
            print("ERROR: \(msg) \(error), \(error.userInfo)")
        }
        else {
            print("ERROR: \(error), \(error.userInfo)")
        }
    }
}
