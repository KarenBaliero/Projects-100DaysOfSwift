//
//  DetailViewController.swift
//  Milestone-19-21
//
//  Created by Karen Lima on 03/10/21.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var text: UITextView!
    
    var selectedNote: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let note = selectedNote else { return }
        title = note.title
        navigationItem.largeTitleDisplayMode = .always
        
    }
}
