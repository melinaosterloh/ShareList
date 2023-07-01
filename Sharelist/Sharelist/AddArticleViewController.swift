//
//  AddArticleViewController.swift
//  Sharelist
//
//  Created by Melina Osterloh on 19.06.23.
//

import UIKit
import Firebase
import Toast

class AddArticleViewController: UIViewController {

    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var Btn1: UIButton!
    @IBOutlet weak var Btn2: UIButton!
    @IBOutlet weak var Btn3: UIButton!
    @IBOutlet weak var Btn4: UIButton!
    @IBOutlet weak var Btn5: UIButton!
    @IBOutlet weak var Btn6: UIButton!
    
    
    @IBOutlet weak var productname: UITextField!
    @IBOutlet weak var brand: UITextField!
    @IBOutlet weak var quantity: UITextField!
    @IBOutlet weak var category: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Btn1.layer.cornerRadius = 10
        Btn2.layer.cornerRadius = 10
        Btn3.layer.cornerRadius = 10
        Btn4.layer.cornerRadius = 10
        Btn5.layer.cornerRadius = 10
        Btn6.layer.cornerRadius = 10
        
        scrollView.contentSize = CGSize(width: 530, height: scrollView.bounds.size.height)
        
        productname.layer.borderColor = UIColor.darkGray.cgColor
        productname.layer.borderWidth = 1
        productname.layer.cornerRadius = 10
        
        brand.layer.borderColor = UIColor.darkGray.cgColor
        brand.layer.borderWidth = 1
        brand.layer.cornerRadius = 10
        
        quantity.layer.borderColor = UIColor.darkGray.cgColor
        quantity.layer.borderWidth = 1
        quantity.layer.cornerRadius = 10
        
        category.layer.borderColor = UIColor.darkGray.cgColor
        category.layer.borderWidth = 1
        category.layer.cornerRadius = 10
        
        saveBtn.layer.cornerRadius = saveBtn.bounds.height / 2
        saveBtn.layer.shadowRadius = 2
        saveBtn.layer.shadowOpacity = 0.5
        saveBtn.layer.shadowColor = UIColor.darkGray.cgColor
        saveBtn.layer.shadowOffset = CGSize(width: 1, height: 1)
        
    }
    

    @IBAction func addArticleButton(_ sender: UIButton) {
        guard let name = productname.text else {
            return
        }
        guard let brand = brand.text else {
            return
        }
        guard let quantity = quantity.text else {
            return
        }
        guard let cathegory = category.text else {
            return
        }
        
        
        
        if name.isEmpty {
            self.view.makeToast("Bitte gib eine Produktbezeichnung ein!", duration: 2.0)
        }
        else {
            let db = Firestore.firestore()
            let userRef = db.collection("user").document("3MCeDNUzyRtZ5TYnkmqM")
            let shoppinglistRef = userRef.collection("shoppinglist").document("l2lyKnQGD99h4LVTLwWe")
            
            let listRef = shoppinglistRef.collection("WG Liste").document()
            listRef.setData(["productname":name, "brand":brand, "quantity":quantity, "cathegory":cathegory, "id": listRef.documentID]) { error in
                if let error = error {
                    print("Error saving user data:")
                } else {
                    print("User data saved successfully")
                }
            }
            
            self.performSegue(withIdentifier: "goBackToSharelist", sender: self)
        }
    }
    

}
