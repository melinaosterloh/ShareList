//
//  PaymentViewController.swift
//  Sharelist
//
//  Created by Melina Osterloh on 28.06.23.
//

import UIKit
import Firebase

class PaymentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var payDeptBtn: UIButton!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var paymentTableView: UITableView!
    @IBOutlet weak var balance: UILabel!
    
    var userID = Auth.auth().currentUser!.uid
    var db = Firestore.firestore()
    var selectedListID: String?
    var expensesArray = [Expenses]()
    var expenses: Expenses?
    private var document: [DocumentSnapshot] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.paymentTableView.delegate = self
        self.paymentTableView.dataSource = self
        loadData()
        loadDesign()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expensesArray.count
    }
    
    // Table View Cell Höhe
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let expensesCell = tableView.dequeueReusableCell(withIdentifier: "ExpensesTableViewCell", for: indexPath)
        let expenses = expensesArray[indexPath.row]
        let number = expenses.price
        let string = "\(number)"
        let dateString = DateFormatter.localizedString(from: expenses.date, dateStyle: .short, timeStyle: .none)

        expensesCell.textLabel?.text = "\(dateString + "    " + expenses.description)"
        expensesCell.detailTextLabel?.text = "\(string + " €")"
        expensesCell.layer.cornerRadius = 10
        expensesCell.layer.borderColor = UIColor.darkGray.cgColor
        expensesCell.layer.borderWidth = 0.3
        return expensesCell
    }
    
    func loadData() {        
        // Vor dem Laden neuer Daten das listArray leeren
        expensesArray.removeAll()
    
        // Ausgabe der Ausgaben der aktuellen Liste
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
           let selectedListID = appDelegate.selectedListID {
            let shoppingListsRef = self.db.collection("shoppinglist").document(selectedListID).collection("expenses")
                shoppingListsRef.getDocuments { (snapshot, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        if let snapshot = snapshot {
                            for document in snapshot.documents {
                                let data = document.data()
                                let id = data["id"] as? String ?? ""
                                if let timestamp = data["date"] as? Timestamp {
                                    let date = timestamp.dateValue()
                                    
                                    //let date = data["date"] as? Date ?? nil
                                    let description = data["description"] as? String ?? ""
                                    let price = data["price"] as? Double ?? 0
                                    let newExpenses = Expenses(id: id, date: date, description: description, price: price)
                                    self.expensesArray.append(newExpenses)
                                }
                            }
                            // Sortiere das Array nach dem Datum in absteigender Reihenfolge (neuestes Datum zuerst)
                            let sortedExpensesArray = self.expensesArray.sorted { $0.date > $1.date }

                            // Verwende das sortierte Array als Datenquelle für die TableView
                            self.expensesArray = sortedExpensesArray
                            self.paymentTableView.reloadData()
                            self.getUserBalance()
                        }
                    }
                }
            } else {
                print("keine Liste ausgwählt")
            }
    }

    //Anzeige des AccountViewController
    @IBAction func menuButton(_ sender: UIButton) {
        let accountViewController = storyboard?.instantiateViewController(withIdentifier: "AccountViewController") as! AccountViewController
        accountViewController.modalPresentationStyle = .overCurrentContext
        accountViewController.modalTransitionStyle = .crossDissolve
        present(accountViewController, animated: true, completion: nil)
    }
    
    //Anzeige des AccountViewController
    @IBAction func payDeptButton(_ sender: UIButton) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
           let selectedListID = appDelegate.selectedListID {
            let userBalances = self.db.collection("shoppinglist").document(selectedListID).collection("userBalances")
            userBalances.getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Fehler beim Abrufen der Dokumente: \(error.localizedDescription)")
                    return
                }
                for document in querySnapshot?.documents ?? [] {
                    let userBalance = userBalances.document(document.documentID)
                    userBalance.updateData(["balance": 0.00]) { error in
                        if let error = error {
                            print("Fehler beim Aktualisieren des Dokuments: \(error.localizedDescription)")
                        } else {
                            print("Dokument erfolgreich aktualisiert: \(document.documentID)")
                            self.getUserBalance()
                            let currentDate = Date()
                            let debtClearing = Expenses(id: "-", date: currentDate, description: "Schuldenausgleich", price: 0.00)
                            self.expensesArray.append(debtClearing)
                            let newExpense = self.db.collection("shoppinglist").document(selectedListID).collection("expenses").document()
                            newExpense.setData(["description":"Schuldenausgleich", "price":"-", "date":currentDate])
                            // Sortiere das Array nach dem Datum in absteigender Reihenfolge (neuestes Datum zuerst)
                            let sortedExpensesArray = self.expensesArray.sorted { $0.date > $1.date }

                            // Verwende das sortierte Array als Datenquelle für die TableView
                            self.expensesArray = sortedExpensesArray
                            self.paymentTableView.reloadData()
                        }
                    }
                }
                
            }
        }
    }
                        
  
    
    // Gibt die Balance des aktuell angemeldeten Users aus der aktuell ausgewählten Liste aus
    func getUserBalance() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
           let selectedListID = appDelegate.selectedListID {
            let userBalance = self.db.collection("shoppinglist").document(selectedListID).collection("userBalances").document(userID)
            userBalance.getDocument { (document, error) in
                if let document = document, document.exists {
                    if let userBalance = document.data()?["balance"] as? Double {
                        print("userBalance ist", userBalance)
                        let roundedNumber = round(userBalance * 100) / 100 //runden auf zwei Nachkommastellen
                        self.balance.text = String(roundedNumber)
                    } else {
                        self.balance.text = "0.00"
                    }
                }
                else {
                    self.balance.text = "0.00"
                    print("noch keine Ausgaben")
                }
            }
        } else {
            print("keine Liste ausgewählt")
        }
    }
    
    func loadDesign() {
        balance.layer.borderColor = UIColor.darkGray.cgColor
        balance.layer.borderWidth = 1
        balance.layer.cornerRadius = 10
        
        payDeptBtn.layer.cornerRadius = 25
        
        menuBtn.layer.cornerRadius = menuBtn.bounds.height / 2
        menuBtn.layer.shadowRadius = 2
        menuBtn.layer.shadowOpacity = 0.5
        menuBtn.layer.shadowColor = UIColor.darkGray.cgColor
        menuBtn.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        homeBtn.layer.cornerRadius = menuBtn.bounds.height / 2
        homeBtn.layer.shadowRadius = 2
        homeBtn.layer.shadowOpacity = 0.5
        homeBtn.layer.shadowColor = UIColor.darkGray.cgColor
        homeBtn.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        addBtn.layer.cornerRadius = addBtn.bounds.height / 2
        addBtn.layer.shadowRadius = 2
        addBtn.layer.shadowOpacity = 0.5
        addBtn.layer.shadowColor = UIColor.darkGray.cgColor
        addBtn.layer.shadowOffset = CGSize(width: 1, height: 1)
        
    }
    

}
