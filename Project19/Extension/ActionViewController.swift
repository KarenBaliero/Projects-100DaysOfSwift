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

    @IBOutlet var script: UITextView!
    var pageTitle = ""
    var pageURL = ""
    
    //challenge 2
    var userScripts = [UserScript]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(selectOption))
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        //we got a extension context. array of data passed, we get the first one.
        //lets us control how it interacts with the parent app
        //inputItems is an array of data the parent app is sending to our extension to use
        if let inputItem = extensionContext!.inputItems.first as? NSExtensionItem {
            //this contains an array of attachments, are given to us wrapped up as an NSItemProvider
            //the first attachment of the first item
            if let itemProvider = inputItem.attachments?.first {
                // to ask the item provider to actually provide us with its item
                //l [weak self] to avoid strong reference cycle
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String){ [weak self] (dict, error) in
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    
                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                    }
                }
            }
        }
    }
    
    @objc func selectOption () {
        let ac = UIAlertController(title: "Options", message: "Select option", preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Script Examples", style: .default, handler: selectScriptActionSheet))
        ac.addAction(UIAlertAction(title: "Save", style: .default, handler: saveScripts))
        present(ac, animated: true)
    }
    
    func selectScriptActionSheet (action: UIAlertAction) {
        let ac = UIAlertController(title: "Prewritten Scripts", message: "Select script", preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        for (title, script) in scriptExamples {
            ac.addAction(UIAlertAction(title: title, style: .default) { [weak self] _ in
                self?.script.text = script
                
            })
        }
        for example in userScripts {
            ac.addAction(UIAlertAction(title: example.title, style: .default) { [weak self] _ in
                self?.script.text = example.script
                
            })
        }
        present(ac, animated: true)
    }
    
    func executeScript(script: String){
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": script]
        let webDicitionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDicitionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        extensionContext?.completeRequest(returningItems: [item])
    }
    
    @IBAction func done() {
        executeScript(script: script.text)
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        // self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        script.scrollIndicatorInsets = script.contentInset
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }
    
    func saveScripts(action: UIAlertAction){
        let userScriptToBeSaved = UserScript(title: "hello", script: (self.script.text ?? "" ))
        let ac = UIAlertController(title: "Title", message: "Add Title", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Save", style: .default){
            [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else {return}
            userScriptToBeSaved.title = newName
            self?.userScripts.append(userScriptToBeSaved)
            self?.save()
            //person.name = newName
            //self?.save()
            //self?.collectionView.reloadData()
            //print(person.name)
        })
        present(ac, animated: true)
        
       
    }
    
    func save(){
        
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(userScripts) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "userScripts")
            print(userScripts)
            print("Saved \(userScripts.last?.title ?? "") \(userScripts.last?.script ?? "")")
        } else {
            print("Failed to save")
        }
        print(userScripts)
    }

}
