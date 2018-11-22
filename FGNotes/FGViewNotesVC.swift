//
//  FGNotesVC.swift
//  FGNotes
//
//  Created by Foram Dadhania on 2018-11-21.
//  Copyright © 2018 Foram Dadhania. All rights reserved.
//

import UIKit

class FGViewNotesVC: UIViewController {

    @IBOutlet weak var hamburgerView: UIView!
    @IBOutlet weak var hamburgerLeadingConstraint: NSLayoutConstraint!
    var hamburgerOpen: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        hamburgerLeadingConstraint.constant = -400
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
            print("Sort by Title clicked")
        case 11:
            print("Sort by Date/Time clicked")
        case 12:
            print("Sort by Subject clicked")
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

}
