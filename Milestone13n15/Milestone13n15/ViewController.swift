//
//  ViewController.swift
//  Milestone13n15
//
//  Created by Karen Lima on 18/09/21.
//

import UIKit

class ViewController: UITableViewController {

    var countries = [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let urlString: String
        urlString = "/Users/karenlima/Documents/Estudos 100 days of Swift/Project1-1/Milestone13n15/Milestone13n15/Contents/countries.json"
        if let url = URL(string: urlString){
            print("urldeu")
            if let data = try? Data(contentsOf: url){
                parse(json: data)
                return
            }
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let country = countries[indexPath.row]
        cell.textLabel?.text = country.name
        cell.detailTextLabel?.text = country.capital
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let vc = Deta
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        if let jsonCountries = try? decoder.decode(Countries.self, from: json){
            countries = jsonCountries.results
            tableView.reloadData()
        }
    }




}

