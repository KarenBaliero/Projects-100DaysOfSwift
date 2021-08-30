//
//  ViewController.swift
//  Project7
//
//  Created by Karen Lima on 23/08/21.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var originalPetitions = [Petition]()
    var searchWord: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredits))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(stringSearch))
        
        let urlString: String
        if navigationController?.tabBarItem.tag == 0{
            //urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
                urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url){
                parse(json: data)
                return
            }
        }
        showError()
    }
    
    @objc func stringSearch(){
        let ac = UIAlertController(title: "Enter search word:", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default ) {
            [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.searchWord = answer
            //performSelector(inBackground: #selector(self.filterPetitions), with: nil)
            DispatchQueue.global().async {
                self?.filterPetitions()
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    @objc func showCredits(){
        let ac = UIAlertController(title: "Credits", message: "The data comes from the We The People API of the Whitehouse.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
        
    }
    
    func showError(){
        let ac = UIAlertController(title: "Loading Error", message: "There was a problem loading the feed; please check your connection;", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            originalPetitions = jsonPetitions.results
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
    }
    
    @objc func filterPetitions() {
        if searchWord.isEmpty{
            petitions = originalPetitions
            return
        }
        petitions = originalPetitions.filter() { petition in
            if let _ = petition.title.range(of: searchWord, options: .caseInsensitive ){
                return true
            }
            if let _ = petition.body.range(of: searchWord, options: .caseInsensitive){
                return true
            }
            return false
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }


}

