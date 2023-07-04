//
//  PaymentViewController.swift
//  Sharelist
//
//  Created by Melina Osterloh on 28.06.23.
//

import UIKit
import Firebase

class PaymentViewController: UIViewController {

    @IBOutlet weak var payDeptBtn: UIButton!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var homeBtn: UIButton!
    
    @IBOutlet weak var balance: UILabel!
    var userID = Auth.auth().currentUser!.uid
    
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
    
    func getUserBalance() {
        let db = Firestore.firestore()
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
           let selectedListID = appDelegate.selectedListID {
            let userBalance = db.collection("shoppinglist").document(selectedListID).collection("userBalances").document(userID)
            userBalance.getDocument { (document, error) in
                if let document = document, document.exists {
                    if let userBalance = document.data()?["balance"] as? Double {
                        let roundedNumber = round(userBalance * 100) / 100
                        self.balance.text = String(roundedNumber)
                    } else {
                        self.balance.text = "0,00"
                        
                    }
                }
                else { print("keine Liste") }
            }
        }
    }
    
    func loadDesign() {
        
        balance.layer.borderColor = UIColor.darkGray.cgColor
        balance.layer.borderWidth = 1
        balance.layer.cornerRadius = 10
        getUserBalance()
        
        
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
        
    }
    

}
