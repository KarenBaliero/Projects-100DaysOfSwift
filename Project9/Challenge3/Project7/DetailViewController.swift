//
//  DetailViewController.swift
//  Project7
//
//  Created by Karen Lima on 24/08/21.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var detailItem: Petition?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView()
        view = webView

        guard let detailItem = detailItem else { return }
        let html = """
            <html>
            <head>
            <meta name="viewport" content="width=devide-width, initial-scale=1">
            <style> body { font-size: 150% } </style>
            </head>
            <body>
            \(detailItem.body)
            <body>
            </html>
            """
        
        webView.loadHTMLString(html, baseURL: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
