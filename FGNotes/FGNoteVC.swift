//
//  FGNoteOperationsVC.swift
//  FGNotes
//
//  Created by Foram Dadhania on 2018-11-21.
//  Copyright © 2018 Foram Dadhania. All rights reserved.
//

import UIKit

class FGNoteVC: UIViewController {
    
    var selectedSubjectID:Int = 0
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var locationSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Note ID: \(sharedDatabaseManager.getLastNoteIDFromNotes())")
        print("Selected Subject ID: \(selectedSubjectID)")
        let df = DateFormatter()
        df.dateFormat = "yyyy-MMM-dd hh:mm:ss a"
        dateLabel.text = df.string(from: Date())
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        let tempNote: Note = Note.init()
        tempNote.id = sharedDatabaseManager.getLastNoteIDFromNotes()
        tempNote.subId = selectedSubjectID
        tempNote.title = titleTextField.text!
        tempNote.date = dateLabel.text!
        tempNote.content = contentTextView.text!
        sharedDatabaseManager.insertIntoTempNoteTable(note: tempNote)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveNoteAction(_ sender: Any) {
        let note: Note = Note.init()
        note.id = sharedDatabaseManager.getLastNoteIDFromNotes()
        note.subId = selectedSubjectID
        note.title = titleTextField.text!
        print(note.title)
        note.date = dateLabel.text!
        note.content = contentTextView.text!
        sharedDatabaseManager.insertIntoNoteTable(note: note)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
