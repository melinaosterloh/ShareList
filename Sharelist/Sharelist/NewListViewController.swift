//
//  NewListViewController.swift
//  Sharelist
//
//  Created by Melina Osterloh on 28.06.23.
//

import UIKit
import Firebase
import Toast

protocol ReloadListDelegate: AnyObject {
    func reloadListTableView()
}

class NewListViewController: UIViewController {


    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var listName: UITextField!
    @IBOutlet weak var createListBtn: UIButton!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var inviteBtn: UIButton!
    @IBOutlet weak var listNameLabel: UILabel!
    @IBOutlet weak var member1: UILabel!
    @IBOutlet weak var member2: UILabel!
    @IBOutlet weak var member3: UILabel!
    @IBOutlet weak var member4: UILabel!
    @IBOutlet weak var member5: UILabel!
    
    var currentUser : String?
    var listname: String?
    var memberArray = [String]()
    weak var reloadDelegate: ReloadListDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDesign()

    }

    @IBAction func closeBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    
    // Eingegebener Listenname wird zum Label, Textfeld und Button verschwinden
    @IBAction func createListButton(_ sender: UIButton) {
        if let name = listName.text, !name.isEmpty {
            listname = name
            listNameLabel.text = listname
            listName.isHidden = true
            createListBtn.isHidden = true
            currentUser = Auth.auth().currentUser?.uid
            memberArray.append(currentUser!)
        }
        else {
            self.view.makeToast("Bitte gib einen Listennamen ein!", duration: 2.0)
        } 
    }
    
    @IBAction func checkButton(_ sender: UIButton) {
        if let name = listname {
            let db = Firestore.firestore()
            let newList = db.collection("shoppinglist").document()
            newList.setData(["name": name, "balance":0, "owner": memberArray])
            // new List is selected
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.updateSelectedListID(newList.documentID) // newListID ist der Wert der neuen Listen-ID
            }
            print("Listen ID ist:", newList.documentID)
            print(memberArray)
            dismiss(animated: true) {
                if let delegate = self.reloadDelegate {
                    delegate.reloadListTableView()
                    
                }
            }
        }
    }
    
    // E-Mail Adresse aus E-Mail Textfeld wird in die 5 zur verfügung stehenden Label gespeichert
    @IBAction func inviteButton(_ sender: UIButton) {
        let email = emailTF.text
        let maxMember = 5
        // Abfrage, ob Listenname angegeben wurde, um Liste zu erstellen
        if let listNameLabelText = listNameLabel.text, !listNameLabelText.isEmpty {
            // Abfrage, ob E-Mail Felf für die Mitglieder ausgefüllt wurde
            if let emailTF = emailTF.text, !emailTF.isEmpty {
                // Abfrage, ob die E-Mail Adresse in der App Registriert ist
                getUIDFromEmail(email: emailTF) { uid in
                    if let uid = uid {
                        // Überprüfung nach freien Labels für die Mitglieder (max. 5)
                        if let mem1Text = self.member1.text, mem1Text.isEmpty {
                            self.member1.text = email
                            self.memberArray.append(uid)
                        }
                        else if let mem2Text = self.member2.text, mem2Text.isEmpty {
                            self.member2.text = email
                            self.memberArray.append(uid)
                        }
                        else if let mem3Text = self.member3.text, mem3Text.isEmpty {
                            self.member3.text = email
                            self.memberArray.append(uid)
                        }
                        else if let mem4Text = self.member4.text, mem4Text.isEmpty {
                            self.member4.text = email
                            self.memberArray.append(uid)
                        }
                        else if let mem5Text = self.member5.text, mem5Text.isEmpty {
                            self.member5.text = email
                            self.memberArray.append(uid)
                        }
                        else {
                            self.view.makeToast("Es können nicht mehr Mitglieder hinzugefügt werden!", duration: 2.0)
                        }
  
                    } else {
                        self.view.makeToast("User nicht gefunden!", duration: 2.0)
                    }
                }
            }
            else {
                print("Es wurde keine UID für die E-Mail-Adresse gefunden")
            }
        }
        else {
            self.view.makeToast("Bitte fülle zuerste den Listennamen aus!", duration: 2.0)
        }
    }
    
    func getUIDFromEmail(email: String, completion: @escaping (String?) -> Void) {
        Auth.auth().fetchSignInMethods(forEmail: email) { signInMethods, error in
            if let error = error {
                print("Fehler beim Abrufen der UID:", error.localizedDescription)
                completion(nil)
                return
            }
            let db = Firestore.firestore()
            db.collection("user").whereField("email", isEqualTo: email).getDocuments { snapshot, error in
                if let error = error {
                    print("Fehler beim Abrufen der UID:", error.localizedDescription)
                    completion(nil)
                    return
                }
                            
                if let snapshot = snapshot, let document = snapshot.documents.first {
                    let uid = document.documentID
                    completion(uid)
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    
    func loadDesign() {
        
        // Textfeld Listenname
        listName.layer.borderColor = UIColor.darkGray.cgColor
        listName.layer.borderWidth = 1
        listName.layer.cornerRadius = 10
        listName.layer.masksToBounds = true
        listName.layer.shadowRadius = 2
        listName.layer.shadowOpacity = 0.5
        listName.layer.shadowColor = UIColor.darkGray.cgColor
        listName.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        // Button "Erstellen"
        createListBtn.layer.cornerRadius = 10
        createListBtn.layer.shadowRadius = 2
        createListBtn.layer.shadowOpacity = 0.5
        createListBtn.layer.shadowColor = UIColor.darkGray.cgColor
        createListBtn.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        // Textfeld E-Mail Adresse
        emailTF.layer.borderColor = UIColor.darkGray.cgColor
        emailTF.layer.borderWidth = 1
        emailTF.layer.cornerRadius = 10
        emailTF.layer.masksToBounds = true
        emailTF.layer.shadowRadius = 2
        emailTF.layer.shadowOpacity = 0.5
        emailTF.layer.shadowColor = UIColor.darkGray.cgColor
        emailTF.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        // Button "Einladen"
        inviteBtn.layer.cornerRadius = 10
        inviteBtn.layer.shadowRadius = 2
        inviteBtn.layer.shadowOpacity = 0.5
        inviteBtn.layer.shadowColor = UIColor.darkGray.cgColor
        inviteBtn.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        // Button Schließen des Overlays
        closeBtn.layer.cornerRadius = closeBtn.bounds.height / 2
        closeBtn.layer.shadowRadius = 2
        closeBtn.layer.shadowOpacity = 0.5
        closeBtn.layer.shadowColor = UIColor.darkGray.cgColor
        closeBtn.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        // Button Speichern der neuen Liste
        checkBtn.layer.cornerRadius = checkBtn.bounds.height / 2
        checkBtn.layer.shadowRadius = 2
        checkBtn.layer.shadowOpacity = 0.5
        checkBtn.layer.shadowColor = UIColor.darkGray.cgColor
        checkBtn.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        listNameLabel.textColor = .white
        member1.textColor = .white
        member2.textColor = .white
        member3.textColor = .white
        member4.textColor = .white
        member5.textColor = .white
    }
    
    
}
