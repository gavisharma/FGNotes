//
//  FGNoteOperationsVC.swift
//  FGNotes
//
//  Created by Foram Dadhania on 2018-11-21.
//  Copyright © 2018 Foram Dadhania. All rights reserved.
//

import UIKit

class FGNoteVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        sharedDatabaseManager.insertIntoTempNoteTable(note: Note.init())
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveNoteAction(_ sender: Any) {
        sharedDatabaseManager.insertIntoNoteTable(note: Note.init())
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
