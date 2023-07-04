//
//  RegistrationViewController.swift
//  Sharelist
//
//  Created by Melina Osterloh on 18.06.23.
//

import UIKit
import Firebase
import Toast

class RegistrationViewController: UIViewController {

    @IBOutlet weak var firstnameRegistration: UITextField!
    @IBOutlet weak var lastnameRegistration: UITextField!
    @IBOutlet weak var emailRegistration: UITextField!
    @IBOutlet weak var passwordRegistration: UITextField!
    @IBOutlet weak var pwRepeat: UITextField!
    @IBOutlet weak var registrationBtn: UIButton!
    @IBOutlet weak var UserImageView: UIImageView!
    @IBOutlet weak var SelectImageBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDesign()
    }
    
    @IBAction func selectImage(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
               imagePicker.sourceType = .photoLibrary
               imagePicker.delegate = self
               present(imagePicker, animated: true, completion: nil)
           }
       }

       extension RegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
           func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
               if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                   // Setze das ausgewählte Bild in der UIImageView
                   UserImageView.image = selectedImage
                   
                   let circleSize: CGFloat = 150.0 // Die gewünschte Größe des Kreises

                   // Bild als Kreis anzeigen
                   UserImageView.layer.cornerRadius = circleSize / 2
                   UserImageView.layer.masksToBounds = true
                   UserImageView.frame = CGRect(x: 0, y: 0, width: circleSize, height: circleSize)
               }
               
               picker.dismiss(animated: true, completion: nil)
           }


           func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
               picker.dismiss(animated: true, completion: nil)
           }
    
    

    @IBAction func registrationBtn(_ sender: UIButton) {
        
        guard let firstname = firstnameRegistration.text else {
            return
        }
        guard let lastname = lastnameRegistration.text else {
            return
        }
        guard let email = emailRegistration.text else {
            return
        }
        guard let password = passwordRegistration.text else {
            return
        }
        
        guard let pwRepeat = pwRepeat.text else { return }
        
        let db = Firestore.firestore()
        
        // neuen User erstellen/ Registrieren
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] firebaseResult, error in
            guard let strongSelf = self else {
                return
            }
            guard password == pwRepeat else {
                strongSelf.view.makeToast("Passwort stimmt nicht überein", duration: 3.0)
                print("Error at Registration")
                return;
            }
            guard error == nil else {
                if let err = error as NSError? {
                    print("Fehler bei der Registrierung:", err.localizedDescription)
                    strongSelf.view.makeToast(err.localizedDescription, duration: 3.0)
                }
                return
            }
            guard let user = firebaseResult?.user else {
                print("user not found")
                return
            }
            let userID = user.uid
            createDefaultList(userID: userID)
            strongSelf.performSegue(withIdentifier: "goToList", sender: self)
        }
        
        func createDefaultList(userID : String) {
            let newList = db.collection("shoppinglist").document()
            newList.setData(["name":"Privat", "balance":0, "owner": [userID]])
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.updateSelectedListID(newList.documentID)
            }
            print("Listen ID ist:", newList.documentID)
            let newUser = db.collection("user").document(userID)
            newUser.setData(["defaultListID": newList.documentID, "name": firstname, "email": email])
        }

    }
           

   func loadDesign() {
       // Bild auswählen Button
       SelectImageBtn.layer.cornerRadius = SelectImageBtn.bounds.height / 2
       SelectImageBtn.layer.shadowRadius = 2
       SelectImageBtn.layer.shadowOpacity = 0.5
       SelectImageBtn.layer.shadowColor = UIColor.darkGray.cgColor
       SelectImageBtn.layer.shadowOffset = CGSize(width: 1, height: 1)
       
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
    

}
