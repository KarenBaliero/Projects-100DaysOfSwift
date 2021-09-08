//
//  ViewController.swift
//  Project12
//
//  Created by Karen Lima on 07/09/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        
        defaults.set(25, forKey: "Age")
        defaults.set(true, forKey: "UserFaceID")
        defaults.set(CGFloat.pi, forKey: "Pi")
        defaults.set("Paul Hudson", forKey: "Name")
        defaults.set(Date(), forKey: "LastRun")
        
        let array = ["Hello", "World"]
        defaults.set(array, forKey: "SavedArray")
        
        let dict = ["Name": "Paul", "Country": "UK"]
        defaults.set(dict, forKey: "SavedDictionary")
        
        let savedInteger = defaults.integer(forKey: "Age")
        
        let savedBoolean = defaults.bool(forKey: "UseFaceID")
    
        let savedArray = defaults.object(forKey: "SavedArray") as? [String] ?? [String]()
        
        let savedDictionay = defaults.object(forKey: "SavedDictionary") as? [String: String] ?? [String: String]()
        
        let savedArray2 = defaults.array(forKey: <#T##String#>)
    }


}

