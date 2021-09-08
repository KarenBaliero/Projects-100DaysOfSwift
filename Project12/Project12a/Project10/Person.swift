//
//  Person.swift
//  Project10
//
//  Created by Karen Lima on 02/09/21.
//

import UIKit

class Person: NSObject, NSCoding {
    
    var name: String
    var image: String
    
    init(name: String, image: String){
        self.name = name
        self.image = image
    }
    
    //from disk
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        image = aDecoder.decodeObject(forKey: "image") as? String ?? ""
    }
    
    //to disk
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(image, forKey: "image")
    }
}
