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
            return
        }
        guard let price = basketPrice.text else {
            return
        }
        guard let date = basketDate.text else {
            return
        }
        if description.isEmpty {
            self.view.makeToast("Bitte gib eine Beschreibung ein!", duration: 2.0)
        }
        else if price.isEmpty {
            self.view.makeToast("Bitte gib einen Preis ein!", duration: 2.0)
        }
        else {
            let db = Firestore.firestore()
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
               let selectedListID = appDelegate.selectedListID {
                let newExpense = db.collection("shoppinglist").document(selectedListID).collection("expenses").document()
                newExpense.setData(["description":description, "price":Double(price)!, "date":date])
                
                //member aus der Datenbank ausgeben
                let members = db.collection("shoppinglist").document(selectedListID)
                splitExpenses(expense: Double(price)!)
                self.performSegue(withIdentifier: "goToExpensesList", sender: self)
            }

        }
        
    }
    
    func splitExpenses (expense: Double) {
       
    }
    
}
