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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        basketDate.inputView = datePicker
        basketDate.text = formatDate(date: Date())
    }
    
    @objc func dateChange(datePicker: UIDatePicker) {
        basketDate.text = formatDate(date: datePicker.date)
    }
    
    func formatDate(date: Date) -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd.MMMM.yyyy"
        return dateFormat.string(from: date)
    }
    
    @IBAction func menuButton(_ sender: UIButton) {
        let accountViewController = storyboard?.instantiateViewController(withIdentifier: "AccountViewController") as! AccountViewController
        accountViewController.modalPresentationStyle = .overCurrentContext
        accountViewController.modalTransitionStyle = .crossDissolve
        present(accountViewController, animated: true, completion: nil)
    }
    
    @IBAction func checkButton(_ sender: UIButton) {
        guard let description = basketDescription.text else {
            self.view.makeToast("Bitte gib eine Beschreibung ein!", duration: 2.0)
            return
        }
        guard let price = Double(basketPrice.text!) else {
                self.view.makeToast("Bitte gib einen Preis ein!", duration: 2.0)
            return
        }
        guard let date = basketDate.text else {
            return
        }
        
            let db = Firestore.firestore()
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
               let selectedListID = appDelegate.selectedListID {
                let currentList = db.collection("shoppinglist").document(selectedListID)
                let newExpense = currentList.collection("expenses").document()
                //let priceDec = Decimal(string: price)!
                newExpense.setData(["description":description, "price":price, "date":date])
                currentList.getDocument { (document, error) in
                    if let document = document, document.exists {
                        // Array der Listen Besitzer/Mitglieder
                        if let listMember = document.data()?["owner"] as? [String] {
                            
                            self.splitExpenses(expense: price, member: listMember, listID: selectedListID)
                            print("Array aus Firebase: \(listMember)")
                        } else {
                            print("Feld existiert nicht oder hat keinen Wert")
                        }
                    } else {
                        // Das Dokument wurde nicht gefunden oder es gab einen Fehler
                        print("Das Dokument existiert nicht oder es gab einen Fehler: \(error?.localizedDescription ?? "")")
                    }
                    self.performSegue(withIdentifier: "goToExpensesList", sender: self)
                }
                
            }
            
    }
    
    
    func splitExpenses (expense: Double, member: Array<String>, listID: String) {
        let db = Firestore.firestore()
        let memberCount = Double(member.count)
        let share = expense/memberCount
        
        for i in member {
            print(i)
            let userBalance = db.collection("shoppinglist").document(listID).collection("userBalances").document(i)
            userBalance.getDocument { (document, error) in
                if let document = document, document.exists {
                    if var currentBalance = document.data()?["balance"] as? Double {
                        // Aktualisiere den Preiswert in Firestore
                        if i == self.userID {
                            userBalance.setData(["balance": currentBalance+(expense-share)], merge: true) { error in
                                if let error = error {
                                    print("Fehler beim Aktualisieren des Zellenpreises: \(error.localizedDescription)")
                                }
                            }
                        } else {
                            userBalance.setData(["balance": currentBalance-share], merge: true) { error in
                                if let error = error {
                                    print("Fehler beim Aktualisieren des Zellenpreises: \(error.localizedDescription)")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
