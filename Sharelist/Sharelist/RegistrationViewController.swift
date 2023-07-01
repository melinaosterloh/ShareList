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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                strongSelf.view.makeToast("Passwort stimmt nicht überein", duration: 2.0)
                print("Error at Registration")
                return;
            }
            guard error == nil else {
                if let err = error as NSError? {
                    print("Fehler bei der Registrierung:", err.localizedDescription)
                    strongSelf.view.makeToast(err.localizedDescription, duration: 2.0)
                }
            return;
            }
            guard let user = firebaseResult?.user else {
                // Bei einem Fehler während der Registrierung
                // Behandeln Sie den Fehler entsprechend
                return
            }

            let userID = user.uid
            createDefaultList(userID: userID)
            strongSelf.performSegue(withIdentifier: "goToList", sender: self)
        }
        
        func createDefaultList(userID : String) {
            let newList = db.collection("shoppinglist").document()
            newList.setData(["name":"Privat", "balance":0, "id": newList.documentID])
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.updateSelectedListID(newList.documentID) // newListID ist der Wert der neuen Listen-ID
            }
            print("Listen ID ist:", newList.documentID)
            let newUser = db.collection("user").document(userID)
            newUser.setData(["defaultListID": newList.documentID, "name": firstname])
            /*let list = db.collection("shoppinglist").document(newList.documentID)
            let listUser = list.collection("user").document(userID)
            listUser.setData(["firstname": firstname, "lastname": lastname, "listID": newList.documentID])*/
            let newArticle = newList.collection("article").document()
            newArticle.setData(["productname":"Apfel", "brand":"Pink Lady", "quantity":5, "cathegory":"Obst", "id": newArticle.documentID])
        }
    }
    

}
