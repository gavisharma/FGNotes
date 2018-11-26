//
//  FGSelectSubjectVC.swift
//  FGNotes
//
//  Created by Foram Dadhania on 2018-11-21.
//  Copyright © 2018 Foram Dadhania. All rights reserved.
//

import UIKit

class FGSelectSubjectVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var subjectsArray:[Subject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
//        sharedDatabaseManager.getListOfAllSubjects()
//        subjectsArray = [["id":1, "name":"SWIFT"], ["id":2, "name":"ObjectiveC"], ["id":3, "name":"ORACLE"], ["id":4, "name":"Java"], ["id":5, "name":"JS"], ["id":6, "name":"C"], ["id":7, "name":"C++"], ["id":8, "name":"PHP"], ["id":9, "name":"ASP"], ["id":10, "name":"HTML"],]
        subjectsArray = sharedDatabaseManager.getListOfAllSubjects()!
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonEvent(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addNoteVC(_ sender: Any) {
//        let noteVC:FGNoteVC = storyboard?.instantiateViewController(withIdentifier: "NoteVC") as! FGNoteVC
//        self.present(noteVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjectsArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let subjectCell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "subjectCell")!
        let subName : UILabel = subjectCell.viewWithTag(1) as! UILabel
        let sub: Subject = subjectsArray[indexPath.row]
        subName.text = sub.title
        return subjectCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let noteVC:FGNoteVC = storyboard?.instantiateViewController(withIdentifier: "NoteVC") as! FGNoteVC
        let sub: Subject = subjectsArray[indexPath.row]
        noteVC.selectedSubjectID = sub.id
        self.present(noteVC, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
