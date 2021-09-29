//
//  UserScript.swift
//  Extension
//
//  Created by Karen Lima on 28/09/21.
//

import UIKit

class UserScript: NSObject, Codable {
    var title: String
    var script: String
    
    init(title: String, script: String){
        self.title = title
        self.script = script
    }
}
