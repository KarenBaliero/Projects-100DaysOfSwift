//
//  ViewController.swift
//  Project18
//
//  Created by Karen Lima on 23/09/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print("Im inside view did load")
        //print(1, 2, 3, 4, 5, separator: "-")
        //print(1, 2, 3, 4, 5, terminator: "-")
        //assert will not be in the final code, in the live app
        //assert(myReallySlowMethod() == true,  "Bad thing"assert(1==1, "Math failure")
        //assert(1==2, "Math failure 2!")
        for i in 1...100{
            print("Got number \(i)")
        }
    }


}

