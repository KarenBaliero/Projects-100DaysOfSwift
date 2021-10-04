//
//  ViewController.swift
//  Milestone-19-21
//
//  Created by Karen Lima on 03/10/21.
//

import UIKit

class ViewController: UITableViewController {

    var notes = [Note]()
    
    var newNoteButton: UIBarButtonItem!
    var spacerButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
        spacerButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        newNoteButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(newNote))
        toolbarItems = [ spacerButton, newNoteButton ]
        navigationController?.isToolbarHidden = false
    }
    
    func openDetail(noteIndex: Int){
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedNote = notes[noteIndex]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func newNote(){
        notes.append(Note(title: "", body: "", dataCreation: Date()))
        openDetail(noteIndex: notes.count - 1)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openDetail(noteIndex: indexPath.row)
    }

}

