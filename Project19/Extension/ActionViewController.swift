//
//  ActionViewController.swift
//  Extension
//
//  Created by Karen Lima on 26/09/21.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ActionViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //we got a extension context. array of data passed, we get the first one.
        //lets us control how it interacts with the parent app
        //inputItems is an array of data the parent app is sending to our extension to use
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            //this contains an array of attachments, are given to us wrapped up as an NSItemProvider
            //the first attachment of the first item
            if let itemProvider = inputItem.attachments?.first {
                // to ask the item provider to actually provide us with its item
                //l [weak self] to avoid strong reference cycle
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String){ [weak self] (dict, error) in
                    
                    //do stuff
                }
            }
        }
    }

    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }

}
