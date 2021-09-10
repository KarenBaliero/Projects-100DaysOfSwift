//
//  ViewController.swift
//  Project10
//
//  Created by Karen Lima on 01/09/21.
//


import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var people = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        
        let defaults = UserDefaults.standard
        
        if let savedPeople = defaults.object(forKey: "people") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                people = try jsonDecoder.decode([Person].self, from: savedPeople)
            } catch {
                print("Failed to load people")
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue PersonCell.")
        }
        let person = people[indexPath.item]
        
        cell.name.text = person.name
        
        let path = getDocumentDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    
    @objc func addNewPerson (){
        let ac = UIAlertController(title: "Source", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Camera", style: .default, handler: selectCamera))
        ac.addAction(UIAlertAction(title: "Gallery", style: .default, handler: selectPicker))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
    
    func selectPicker(action: UIAlertAction){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
       
        present(picker, animated: true)
    }
    func selectCamera(action: UIAlertAction){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.sourceType = .camera
        }
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        let imageName = UUID().uuidString
        let imagePath = getDocumentDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8){
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "Unknow", image: imageName)
        people.append(person)
        save()
        collectionView?.reloadData()
        dismiss(animated: true)
    }
    
    func getDocumentDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let person = people[indexPath.row]
//        let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
//
//        ac.addTextField()
//
//        ac.addAction(UIAlertAction(title: "OK", style: .default){
//            [weak self, weak ac] _ in
//            guard let newName = ac?.textFields?[0].text else {return}
//            person.name = newName
//            self?.collectionView.reloadData()
//        })
//        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//        present(ac, animated: true)
//    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.row]
        
        let acChooseOptions = UIAlertController(title: "Choose Action", message: "Choose what you want to do with the picture", preferredStyle: .actionSheet)
        acChooseOptions.addAction(UIAlertAction(title: "Rename", style: .default){
            [weak self] action in
            self?.renamePerson(person)
        })
        acChooseOptions.addAction(UIAlertAction(title: "Delete", style: .destructive){
            [weak self] action in
            self?.deletePerson(indexPath)
        })
        acChooseOptions.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(acChooseOptions, animated: true)
    }
    
    func renamePerson(_ person: Person){
        let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
        
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "OK", style: .default){
            [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else {return}
            person.name = newName
            self?.save()
            self?.collectionView.reloadData()
            print(person.name)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func deletePerson(_ indexPath: IndexPath){
        self.people.remove(at: indexPath.item)
        collectionView?.reloadData()
    }
    
    func save(){
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(people) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "people")
        } else {
            print("Failed to save")
        }
    }
 
}

