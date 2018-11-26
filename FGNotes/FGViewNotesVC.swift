//
//  FGNotesVC.swift
//  FGNotes
//
//  Created by Foram Dadhania on 2018-11-21.
//  Copyright © 2018 Foram Dadhania. All rights reserved.
//

import UIKit

class FGViewNotesVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var notesTableView: UITableView!
    @IBOutlet weak var hamburgerView: UIView!
    @IBOutlet weak var hamburgerLeadingConstraint: NSLayoutConstraint!
    var hamburgerOpen: Bool = false
    var notesArray:[Note] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        hamburgerLeadingConstraint.constant = -400
        notesArray = sharedDatabaseManager.getAllNotesWith(query: "SELECT * FROM NOTE;")!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notesArray = sharedDatabaseManager.getAllNotesWith(query: "SELECT * FROM NOTE;")!
        notesTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func hamburgerClickAction(_ sender: Any) {
        if hamburgerOpen {
            displayHamburger(shouldDisplay: false)
        } else {
            displayHamburger(shouldDisplay: true)
        }
    }
    
    @IBAction func hamburgerMenuItemsClickAction(_ sender: UIButton) {
        switch sender.tag {
        case 10:
            notesArray = sharedDatabaseManager.getAllNotesWith(query: "SELECT * FROM NOTE ORDER BY TITLE ASC;")!
            notesTableView.reloadData()
        case 11:
            notesArray = sharedDatabaseManager.getAllNotesWith(query: "SELECT * FROM NOTE ORDER BY DATE ASC;")!
            notesTableView.reloadData()
        case 12:
            notesArray = sharedDatabaseManager.getAllNotesWith(query: "SELECT * FROM NOTE ORDER BY SUBID ASC;")!
            notesTableView.reloadData()
        case 13:
            print("View subjects clicked")
        case 14:
            print("Add subjects clicked")
        case 15:
            print("Remove subjects clicked")
        default:
            print("Nothing clicked")
        }
        displayHamburger(shouldDisplay: false)
    }
    
    func displayHamburger(shouldDisplay: Bool){
        UIView.animate(withDuration: 5.0, delay: 0.1, options: .curveEaseIn, animations: {
            if shouldDisplay {
                print("Open Hamburger")
                self.hamburgerLeadingConstraint.constant = 0
            } else {
                print("Close Hamburger")
                self.hamburgerLeadingConstraint.constant = -400
            }
        }) { (finished) in
            self.hamburgerOpen = !self.hamburgerOpen
        }
    }
    
    func openHamburger(){
        UIView.animate(withDuration: 1.0, animations: {
            self.hamburgerLeadingConstraint.constant = 0
        }) { (true) in
            self.hamburgerOpen = true
        }
    }
    
    @IBAction func createNoteEvent(_ sender: Any) {
        let selectSubjectVC: FGSelectSubjectVC = storyboard?.instantiateViewController(withIdentifier: "SelectSubject") as! FGSelectSubjectVC
        self.present(selectSubjectVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let noteCell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "noteCell")!
        let titleLabel: UILabel = noteCell.viewWithTag(1) as! UILabel
        let contentLabel:UILabel = noteCell.viewWithTag(2) as! UILabel
        let imgView:UIImageView = noteCell.viewWithTag(3) as! UIImageView
        imgView.image = #imageLiteral(resourceName: "AddNote")
        let note: Note = notesArray[indexPath.row]
        titleLabel.text = note.title
        contentLabel.text = note.content
        return noteCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note: Note = notesArray[indexPath.row]
        let noteVC:FGNoteVC = storyboard?.instantiateViewController(withIdentifier: "NoteVC") as! FGNoteVC
        noteVC.selectedNote = note
        self.present(noteVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let note: Note = notesArray[indexPath.row]
        let deleteQuery = "DELETE FROM NOTE where id = \(note.id)"
        sharedDatabaseManager.deleteFromDatabase(query: deleteQuery)
        notesArray = sharedDatabaseManager.getAllNotesWith(query: "SELECT * FROM NOTE;")!
        notesTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        notesArray = sharedDatabaseManager.getAllNotesWith(query: "SELECT * FROM NOTE ORDER BY LOWER(TITLE) ASC;")!
        notesTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchString: String = "SELECT * FROM NOTE where title like \"%\(searchText.lowercased())%\" OR content like \"%\(searchText.lowercased())%\";"
        notesArray = sharedDatabaseManager.getAllNotesWith(query: searchString)!
        notesTableView.reloadData()
    }

}
