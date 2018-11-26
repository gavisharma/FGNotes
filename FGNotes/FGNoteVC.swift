//
//  FGNoteOperationsVC.swift
//  FGNotes
//
//  Created by Foram Dadhania on 2018-11-21.
//  Copyright © 2018 Foram Dadhania. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

enum ViewMode{
    case createNote
    case viewNote
}

class FGNoteVC: UIViewController, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let imagePickerController = UIImagePickerController()
    var selectedSubjectID:Int = 0
    var selectedNote: Note = Note.init()
    var noteID: Int = 0
    var viewMode: ViewMode = .createNote
    var locationCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D.init()
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var locationSwitch: UISwitch!
    @IBOutlet weak var capturedImageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteID = sharedDatabaseManager.getLastNoteIDFromNotes()
        mapView.showsUserLocation = true
        locationManager.delegate = self
        imagePickerController.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MMM-dd hh:mm:ss a"
        dateLabel.text = df.string(from: Date())
        if viewMode == .viewNote {
            titleTextField.text = selectedNote.title
            dateLabel.text = df.string(from: (selectedNote.date))
            contentTextView.text = selectedNote.content
            if ((selectedNote.isLocationEnabled) == 1) {
                let lat: CGFloat = CGFloat((selectedNote.lat as NSString).doubleValue)
                let lon: CGFloat = CGFloat((selectedNote.lon as NSString).doubleValue)
                locationCoordinate = CLLocationCoordinate2D.init(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lon))
                let region = MKCoordinateRegion(center: locationCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
                self.mapView.setRegion(region, animated: true)
                let annotation = MKPointAnnotation()
                annotation.coordinate = locationCoordinate
                mapView.addAnnotation(annotation)
                
                let imageName: String = "\(selectedNote.id).jpg"
                let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileURL = documentsDirectory.appendingPathComponent("Images/\(imageName)")
                print(fileURL)
                if let imageData = NSData.init(contentsOf: fileURL) {
                    let image = UIImage(data: imageData as Data) // Here you can attach image to UIImageView
                    capturedImageView.image = image
                }
//                capturedImageView.image
            }
        }
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contentTextView.layer.borderColor = UIColor.init(red: 78/255.0, green: 180/255.0, blue: 249/255.0, alpha: 1.0).cgColor
        contentTextView.layer.cornerRadius = 10.0
        contentTextView.layer.borderWidth = 2.0
        capturedImageView.layer.borderColor = UIColor.init(red: 78/255.0, green: 180/255.0, blue: 249/255.0, alpha: 1.0).cgColor
        capturedImageView.layer.cornerRadius = 10.0
        capturedImageView.layer.borderWidth = 2.0
        mapView.layer.borderColor = UIColor.init(red: 78/255.0, green: 180/255.0, blue: 249/255.0, alpha: 1.0).cgColor
        mapView.layer.cornerRadius = 10.0
        mapView.layer.borderWidth = 2.0
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        let tempNote: Note = Note.init()
        tempNote.id = noteID
        tempNote.subId = selectedSubjectID
        tempNote.title = titleTextField.text!
        tempNote.date = Date()
        tempNote.content = contentTextView.text!
        sharedDatabaseManager.insertIntoTempNoteTable(note: tempNote)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveNoteAction(_ sender: Any) {
        if viewMode == .viewNote {
            sharedDatabaseManager.deleteFromDatabase(query: "Delete from Note where id = \(selectedNote.id)")
        }
        let note: Note = Note.init()
        note.id = noteID
        note.subId = selectedSubjectID
        note.title = titleTextField.text!
        note.date = Date()
        note.content = contentTextView.text!
        print(locationCoordinate.latitude)
        note.lat = "\(String(describing: locationCoordinate.latitude))"
        note.lon = "\(String(describing: locationCoordinate.longitude))"
        note.image = "\(noteID).jpg"
        if locationSwitch.isOn {
            note.isLocationEnabled = 1
        } else {
            note.isLocationEnabled = 0
        }
        sharedDatabaseManager.insertIntoNoteTable(note: note)
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- CLLocationMAnager delegates
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            locationCoordinate = CLLocationCoordinate2D.init(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    @IBAction func cameraButtonAction(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Photo Source", message: "Camera", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePickerController.sourceType = .camera
                self.present(self.imagePickerController, animated: true, completion: nil)
            } else {
                print("Camera not available")
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func saveImageLocally(image: UIImage){
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        // choose a name for your image
        let fileName: String = "\(noteID).jpg"
        // create the destination file url to save your image
        let fileURL = documentsDirectory.appendingPathComponent("Images/\(fileName)")
        // get your UIImage jpeg data representation and check if the destination file url already exists
        if let data = UIImageJPEGRepresentation(image, 1.0),
            !FileManager.default.fileExists(atPath: (fileURL.path)) {
            do {
                // writes the image data to disk
                try data.write(to: fileURL)
                print("file saved")
            } catch {
                print("error saving file:", error)
            }
        }
    }
    
    @IBAction func galleryButtonAction(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Photo Source", message: "Photo Library", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction) in self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        capturedImageView.image = image
        saveImageLocally(image: image)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
