//
//  ViewController.swift
//  Milestone Projects 10-12
//
//  Created by Karen Lima on 09/09/21.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var pictures = [Picture]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPicture))
        
//        let defaults = UserDefaults.standard
//
//        if let savedPictures = defaults.object(forKey: "pictures") as? Data {
//            let jsonDecoder = JSONDecoder()
//
//            do {
//                pictures = try jsonDecoder.decode([Picture].self, from: savedPictures)
//            } catch {
//                print("Failed to load people")
//            }
//        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        let picture = pictures[indexPath.row]
        cell.textLabel?.text = picture.name
        
        //let path = getDocumentDirectory().appendingPathComponent(picture.imagePath)
    
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row].imagePath
            vc.index = indexPath.row + 1
            vc.total = pictures.count
            vc.titlePicture = pictures[indexPath.row].name
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    @objc func addNewPicture(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.sourceType = .camera
        }
        present(picker, animated: true)
    }
    
    func getDocumentDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        DispatchQueue.global().async {
            [weak self] in
            let imageName = UUID().uuidString
            let imagePath = self?.getDocumentDirectory().appendingPathComponent(imageName)
            if let jpegData = image.jpegData(compressionQuality: 0.8){
                try? jpegData.write(to: imagePath!)
            }
            
            DispatchQueue.main.sync {
                self?.dismiss(animated: true)
                let ac = UIAlertController(title: "Label picture", message: "Enter a caption", preferredStyle: .alert)
                ac.addTextField()
                
                ac.addAction(UIAlertAction(title: "Save", style: .default){
                    [weak ac] _ in
                    guard let newName = ac?.textFields?[0].text else {return}
                    self?.savePicture(imagePath: imagePath!.path, name: newName)
                })
                ac.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: nil))
                self?.present(ac, animated: true)
            }
        }
    }
    func savePicture(imagePath: String, name: String){
        var newName = name
        if name.isEmpty{
            newName = "Unknow"
        }
        let picture = Picture(name: "\(newName)", imagePath: imagePath)
       
        pictures.append(picture)
        //save()
        tableView?.reloadData()
    }
    
    func labelPicture() -> String{
        var name = ""
        let ac = UIAlertController(title: "Label picture", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "OK", style: .default){
            [weak ac] _ in
            guard let newName = ac?.textFields?[0].text else {return}
            name = newName
            print(newName)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        present(ac, animated: true)
        return name
    }
    
    func save(){
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(pictures){
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "pictures")
        } else{
            print("Failed to save")
        }
    }

}

