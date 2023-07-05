//
//  BasketViewController.swift
//  Sharelist
//
//  Created by Melina Osterloh on 19.06.23.
//

import UIKit
import Firebase

class BasketViewController: UIViewController {
    @IBOutlet weak var basketDescription: UITextField!
    @IBOutlet weak var basketPrice: UITextField!
    @IBOutlet weak var basketDate: UITextField!

    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var menuBtn: UIButton!
    
    var userID = Auth.auth().currentUser!.uid
    var db = Firestore.firestore()
    var selectedDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDesign()
    }
    
    @IBAction func menuButton(_ sender: UIButton) {
        let accountViewController = storyboard?.instantiateViewController(withIdentifier: "AccountViewController") as! AccountViewController
        accountViewController.modalPresentationStyle = .overCurrentContext
        accountViewController.modalTransitionStyle = .crossDissolve
        present(accountViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func checkButton(_ sender: UIButton) {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        //numberFormatter.decimalSeparator = "."
        
        guard let description = basketDescription.text else {
            self.view.makeToast("Bitte gib eine Beschreibung ein!", duration: 2.0)
            return
        }
        guard let inputText = basketPrice.text, !inputText.isEmpty else {
            // Keine Eingabe vorhanden
            self.view.makeToast("Bitte gib einen Preis ein!", duration: 2.0)
            return
        }
        let inputTextWithDecimal = inputText.contains(".") || inputText.contains(",") ? inputText : inputText + ".00"
        guard let price = numberFormatter.number(from: inputText.replacingOccurrences(of: ",", with: "."))?.doubleValue ?? numberFormatter.number(from: inputText)?.doubleValue else {
            // Ungültige Eingabe
            self.view.makeToast("Ungültiger Preis!", duration: 2.0)
            return
        }
        guard let date = selectedDate else {
            return
        }
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
               let selectedListID = appDelegate.selectedListID {
                let currentList = self.db.collection("shoppinglist").document(selectedListID)
                let newExpense = currentList.collection("expenses").document()
                newExpense.setData(["description":description, "price":price, "date": date])
                currentList.getDocument { (document, error) in
                    if let document = document, document.exists {
                        // Array der Listen Besitzer/Mitglieder
                        if let listMember = document.data()?["owner"] as? [String] {
                            let expensesSplitted = self.splitExpenses(expense: price, member: listMember, listID: selectedListID)
                            if expensesSplitted {
                                self.performSegue(withIdentifier: "goToExpensesList", sender: self)
                            }
                        }
                        else {
                            print("Feld existiert nicht oder hat keinen Wert")
                        }
                        
                    } else {
                        // Das Dokument wurde nicht gefunden oder es gab einen Fehler
                        print("Das Dokument existiert nicht oder es gab einen Fehler: \(error?.localizedDescription ?? "")")
                    }
                    
                }
            }
    }
    
    // Funktion zum Aufteilen der Ausgaben
    func splitExpenses (expense: Double, member: Array<String>, listID: String) -> Bool {
        var success = true
        let memberCount = Double(member.count)
        let share = expense/memberCount
        let userBalances = self.db.collection("shoppinglist").document(listID).collection("userBalances")
        // Schleife, die alle Mitglieder der Liste durchläuft und die jeweilige Balance anlegt/aktualisiert
        for i in member {
            let userBalance = userBalances.document(i)
            userBalance.getDocument { (document, error) in
                if let document = document, document.exists {
                    if let currentBalance = document.data()?["balance"] as? Double {
                        // Aktualisiert die Balance in der Datenbank
                        if i == self.userID && memberCount > 1 { // prüft, ob es sich um den aktuell eingeloggten User handelt und ob die Liste mehr als 1 Mitglied hat
                            userBalance.setData(["balance": currentBalance+(expense-share)], merge: true) { error in
                                if let error = error {
                                    print("Fehler beim Aktualisieren der Balance: \(error.localizedDescription)")
                                    success = false
                                }
                            }
                        } else {
                            userBalance.setData(["balance": currentBalance-share], merge: true) { error in
                                if let error = error {
                                    print("Fehler beim Aktualisieren des Zellenpreises: \(error.localizedDescription)")
                                    success = false
                                }
                            }
                        }
                    }
                // Falls der User noch keine Balance hat
                } else {
                    if i == self.userID && memberCount > 1 {
                        let documentData: [String: Double] = ["balance": (expense - share)]
                        userBalances.document(i).setData(documentData) { error in
                            if let error = error {
                                print("Fehler beim Hinzufügen des Dokuments: \(error.localizedDescription)")
                                success = false
                            }
                        }
                    } else {
                        let documentData: [String: Double] = ["balance": -share]
                        userBalances.document(i).setData(documentData) { error in
                            if let error = error {
                                print("Fehler beim Hinzufügen des Dokuments: \(error.localizedDescription)")
                                success = false
                            }
                        }
                    }
                }
            }
        }
        return success
    }
    
    func loadDesign () {
        menuBtn.layer.cornerRadius = menuBtn.bounds.height / 2
        menuBtn.layer.shadowRadius = 2
        menuBtn.layer.shadowOpacity = 0.5
        menuBtn.layer.shadowColor = UIColor.darkGray.cgColor
        menuBtn.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        checkBtn.layer.cornerRadius = checkBtn.bounds.height / 2
        checkBtn.layer.shadowRadius = 2
        checkBtn.layer.shadowOpacity = 0.5
        checkBtn.layer.shadowColor = UIColor.darkGray.cgColor
        checkBtn.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        basketDescription.layer.borderColor = UIColor.darkGray.cgColor
        basketDescription.layer.borderWidth = 1
        basketDescription.layer.cornerRadius = 10
        
        basketPrice.layer.borderColor = UIColor.darkGray.cgColor
        basketPrice.layer.borderWidth = 1
        basketPrice.layer.cornerRadius = 10
        basketPrice.keyboardType = .decimalPad
        
        basketDate.layer.borderColor = UIColor.darkGray.cgColor
        basketDate.layer.borderWidth = 1
        basketDate.layer.cornerRadius = 10
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: UIControl.Event.valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 300)
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.date = Date()
        selectedDate = datePicker.date
        basketDate.inputView = datePicker
        
        basketDate.text = formatDate(date: Date())
    }
    
    @objc func dateChange(datePicker: UIDatePicker) {
        basketDate.text = formatDate(date: datePicker.date)
        selectedDate = datePicker.date
    }
    
    func formatDate(date: Date) -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd.MMMM.yyyy"
        return dateFormat.string(from: date)
    }
}
