//
//  DetailViewController.swift
//  Milestone Projects 10-12
//
//  Created by Karen Lima on 10/09/21.
//

import UIKit

class DetailViewController: UIViewController {
    var selectedImage: String?
    var index: Int?
    var total: Int?
    var titlePicture: String?
    
    
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //title = "Picture \(index!) of \(total!)"
        title = titlePicture
        navigationItem.largeTitleDisplayMode = .never
        if let imagePathToLoad = selectedImage {
            imageView.image = UIImage(contentsOfFile: imagePathToLoad)
        }
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
}
