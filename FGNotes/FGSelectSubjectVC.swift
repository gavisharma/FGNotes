//
//  FGSelectSubjectVC.swift
//  FGNotes
//
//  Created by Foram Dadhania on 2018-11-21.
//  Copyright © 2018 Foram Dadhania. All rights reserved.
//

import UIKit

class FGSelectSubjectVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonEvent(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addNoteVC(_ sender: Any) {
        let noteVC:FGNoteVC = storyboard?.instantiateViewController(withIdentifier: "NoteVC") as! FGNoteVC
        self.present(noteVC, animated: true, completion: nil)
        self.present(noteVC, animated: true) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
