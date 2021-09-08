//
//  ViewController.swift
//  Project1
//
//  Created by Karen Lima on 06/08/21.
//

import UIKit

class ViewController: UITableViewController {
    
    var pictures = [String]()
    var nPictures = [String: Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        for item in items {
            if item.hasPrefix("nssl"){
                pictures.append(item)
            }
        }
        pictures = pictures.sorted()
        print(pictures)
        let defaults = UserDefaults.standard
        
        if let savedNPictures = defaults.object(forKey: "npictures") as? Data {
            if let decodedNPictures = try?
                NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedNPictures) as? [String: Int] {
                nPictures = decodedNPictures
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        cell.detailTextLabel?.text = "View: \(nPictures[pictures[indexPath.row]] ?? 0)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            vc.index = indexPath.row + 1
            vc.total = pictures.count
            nPictures[pictures[indexPath.row], default: 0] += 1
            print(nPictures)
            save()
            DispatchQueue.global().async { [weak self] in
                self?.save()

                DispatchQueue.main.async {
                    self?.navigationController?.pushViewController(vc, animated: true)
                    self?.tableView.reloadRows(at: [indexPath], with: .none)
                }
            }
        }
    }
    
    @objc func shareTapped(){
        let vc = UIActivityViewController(activityItems: [], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    func save() {
        print("saving")
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: nPictures, requiringSecureCoding: false){
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "npictures")
            print("saved")
        }
    }
}

