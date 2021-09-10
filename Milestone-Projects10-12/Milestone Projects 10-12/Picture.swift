//
//  Picture.swift
//  Milestone Projects 10-12
//
//  Created by Karen Lima on 10/09/21.
//

import UIKit

class Picture: NSObject, Codable {
    var name: String
    var imagePath: String
    
    
    init(name: String, imagePath: String) {
        self.name = name
        self.imagePath = imagePath
    }
}
