//
//  RegistrationViewController.swift
//  Sharelist
//
//  Created by Melina Osterloh on 18.06.23.
//

import UIKit
import Firebase
import FirebaseStorage
//import FirebaseAuth
//import FirebaseCore
import Toast

class RegistrationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var firstnameRegistration: UITextField!
    @IBOutlet weak var lastnameRegistration: UITextField!
    @IBOutlet weak var emailRegistration: UITextField!
    @IBOutlet weak var passwordRegistration: UITextField!
    @IBOutlet weak var pwRepeat: UITextField!
    @IBOutlet weak var registrationBtn: UIButton!
    @IBOutlet weak var selectImageBtn: UIButton!
    @IBOutlet weak var defaultImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //var selectedImage: UIImage?
        
        defaultImageView.layer.cornerRadius = 25
            
        selectImageBtn.layer.cornerRadius = 25
        selectImageBtn.layer.shadowRadius = 2
        selectImageBtn.layer.shadowOpacity = 0.5
        selectImageBtn.layer.shadowColor = UIColor.darkGray.cgColor
        selectImageBtn.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        selectImageBtn.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
            
        
        // Vorname Feld
        firstnameRegistration.layer.borderColor = UIColor.darkGray.cgColor
        firstnameRegistration.layer.borderWidth = 1
        firstnameRegistration.layer.cornerRadius = 10
        
        // Nachname Feld
        lastnameRegistration.layer.borderColor = UIColor.darkGray.cgColor
        lastnameRegistration.layer.borderWidth = 1
        lastnameRegistration.layer.cornerRadius = 10
        
        
        // E-Mail Feld
        emailRegistration.layer.borderColor = UIColor.darkGray.cgColor
        emailRegistration.layer.borderWidth = 1
        emailRegistration.layer.cornerRadius = 10
        
        // Passwort Feld
        passwordRegistration.layer.borderColor = UIColor.darkGray.cgColor
        passwordRegistration.layer.borderWidth = 1
        passwordRegistration.layer.cornerRadius = 10
        passwordRegistration.isSecureTextEntry = true
        
        // Passwort wiederholen Feld
        pwRepeat.layer.borderColor = UIColor.darkGray.cgColor
        pwRepeat.layer.borderWidth = 1
        pwRepeat.layer.cornerRadius = 10

        // Registrierung Button
        registrationBtn.layer.cornerRadius = 10
        registrationBtn.layer.shadowRadius = 2
        registrationBtn.layer.shadowOpacity = 0.5
        registrationBtn.layer.shadowColor = UIColor.darkGray.cgColor
        registrationBtn.layer.shadowOffset = CGSize(width: 1, height: 1)
        
    }

    
    @IBAction  func selectImage() {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                defaultImageView.image = pickedImage
            }
            
            dismiss(animated: true, completion: nil)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
        }
    

    @IBAction func registrationBtn(_ sender: UIButton) {
        guard let firstname = firstnameRegistration.text,
              let lastname = lastnameRegistration.text,
              let email = emailRegistration.text,
              let password = passwordRegistration.text,
              let pwRepeat = pwRepeat.text,
              let selectedImage = defaultImageView.image else {
            return
        }
        
        guard password == pwRepeat else {
            view.makeToast("Passwort stimmt nicht überein", duration: 2.0)
            print("Error at Registration")
            return
        }
        
        let db = Firestore.firestore()
        
        // neuen User erstellen/ Registrieren
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] firebaseResult, error in
            guard let strongSelf = self else {
                return
            }
            
            guard error == nil else {
                if let err = error as NSError? {
                    print("Fehler bei der Registrierung:", err.localizedDescription)
                    strongSelf.view.makeToast(err.localizedDescription, duration: 2.0)
                }
                return
            }
            
            guard let user = firebaseResult?.user else {
                print("user not found")
                return
            }
            
            // Generierte User ID des authentifizierten Benutzers
            let userId = user.uid
            let newUser = db.collection("user").document(userId)
            
            // Speicherpfad für das Bild im Storage
            let imageFileName = UUID().uuidString
            let storagePath = "profile_images/\(imageFileName).jpg"
            
            if let imageData = selectedImage.jpegData(compressionQuality: 0.8) {
                let storageRef = Storage.storage().reference().child(storagePath)
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"
                
                // Bild in den Firebase Storage hochladen
                storageRef.putData(imageData, metadata: metadata) { (metadata, error) in
                    if let error = error {
                        print("Fehler beim Hochladen des Bildes: \(error.localizedDescription)")
                        return
                    }
                    
                    // URL des hochgeladenen Bildes aus dem Storage abrufen
                    storageRef.downloadURL { (url, error) in
                        if let error = error {
                            print("Fehler beim Abrufen der Download-URL: \(error.localizedDescription)")
                            return
                        }
                        
                        if let downloadURL = url?.absoluteString {
                            // Bild-URL zu den Registrierungsdaten hinzufügen und in Firestore speichern
                            let userData: [String: Any] = [
                                "firstname": firstname,
                                "lastname": lastname,
                                "email": email,
                                "user_id": userId,
                                "profileImageURL": downloadURL
                                // Weitere Registrierungsdaten können hier hinzugefügt werden
                            ]
                            
                            // Firestore-Dokument erstellen und Registrierungsdaten speichern
                            newUser.setData(userData) { error in
                                if let error = error {
                                    print("Fehler beim Speichern der Registrierungsdaten: \(error.localizedDescription)")
                                } else {
                                    print("Registrierungsdaten wurden erfolgreich gespeichert")
                                }
                            }
                        }
                    }
                }
            }
            
            strongSelf.performSegue(withIdentifier: "goToList", sender: self)
        }
    }
    

}
