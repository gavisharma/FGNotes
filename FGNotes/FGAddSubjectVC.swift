//
//  ViewController.swift
//  FGNotes
//
//  Created by Foram Dadhania on 2018-11-21.
//  Copyright © 2018 Foram Dadhania. All rights reserved.
//

import UIKit

class FGAddSubjectVC: UIViewController {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var textFieldSubject: UITextField!
    var subjectID: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        subjectID = sharedDatabaseManager.getLastSubjectIDFromSubjects()
        idLabel.text = "\(subjectID)"
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func addSubject(_ sender: Any) {
        let subject : Subject = Subject.init()
        subject.id = subjectID
        if (textFieldSubject.text?.count)! > 0 {
            subject.title = textFieldSubject.text!
            sharedDatabaseManager.insertIntoSubjectTable(subject: subject)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}

