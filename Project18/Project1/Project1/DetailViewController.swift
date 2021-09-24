//
//  DetailViewController.swift
//  Project1
//
//  Created by Karen Lima on 07/08/21.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var index: Int?
    var total: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Picture \(index!) of \(total!)"
        navigationItem.largeTitleDisplayMode = .never
        assert(selectedImage != nil, "Não tem imagem")
        //print(selectedImage)
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
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
