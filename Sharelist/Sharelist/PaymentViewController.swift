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
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var addBtn: UIButton!
    
    @IBOutlet weak var paymentTableView: UITableView!
    
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

        expensesCell.textLabel?.text = "\(expenses.date + "    " + expenses.description)"
        expensesCell.detailTextLabel?.text = "\(string + " €")"
        
        expensesCell.layer.cornerRadius = 10
        expensesCell.layer.borderColor = UIColor.darkGray.cgColor
        expensesCell.layer.borderWidth = 0.3
        
        return expensesCell
    }
    
    func loadData() {
        
        // Vor dem Laden neuer Daten das listArray leeren
        expensesArray.removeAll()
        
        let db = Firestore.firestore()
        //initalize Database

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
           let selectedListID = appDelegate.selectedListID {
                print("In der Sharelist ist diese ID angekommen:", selectedListID)
                let shoppingListsRef = db.collection("shoppinglist").document(selectedListID).collection("expenses")
                shoppingListsRef.getDocuments { (snapshot, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        if let snapshot = snapshot {
                            for document in snapshot.documents {
                                let data = document.data()
                                let id = data["id"] as? String ?? ""
                                let date = data["date"] as? String ?? ""
                                let description = data["description"] as? String ?? ""
                                let price = data["price"] as? Double ?? 0
                                let newExpenses = Expenses(id: id, date: date, description: description, price: price)
                                self.expensesArray.append(newExpenses)
                            }
                            self.paymentTableView.reloadData()
                        }
                    }
                }
            } else {
                print("User ist null")
            }
    }
    

    @IBAction func menuButton(_ sender: UIButton) {
        let accountViewController = storyboard?.instantiateViewController(withIdentifier: "AccountViewController") as! AccountViewController
        accountViewController.modalPresentationStyle = .overCurrentContext
        accountViewController.modalTransitionStyle = .crossDissolve
        present(accountViewController, animated: true, completion: nil)
    }
    
    func loadDesign() {
        
        priceTF.layer.borderColor = UIColor.darkGray.cgColor
        priceTF.layer.borderWidth = 1
        priceTF.layer.cornerRadius = 10
        
        payDeptBtn.layer.cornerRadius = 25
        
        menuBtn.layer.cornerRadius = menuBtn.bounds.height / 2
        menuBtn.layer.shadowRadius = 2
        menuBtn.layer.shadowOpacity = 0.5
        menuBtn.layer.shadowColor = UIColor.darkGray.cgColor
        menuBtn.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        homeBtn.layer.cornerRadius = homeBtn.bounds.height / 2
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
