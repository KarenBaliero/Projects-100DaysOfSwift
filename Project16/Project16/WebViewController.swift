//
//  WebViewController.swift
//  Project16
//
//  Created by Karen Lima on 20/09/21.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet var webView: WKWebView!
    
    var url: String!
   
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        guard url != nil else {
            print("Website not set")
            navigationController?.popViewController(animated: true)
            return
        }
        
        
        if let furl = URL(string: url){
            webView.load(URLRequest(url: furl))
        }
        
        
    }
}
