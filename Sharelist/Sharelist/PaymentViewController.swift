//
//  PaymentViewController.swift
//  Sharelist
//
//  Created by Melina Osterloh on 28.06.23.
//

import UIKit

class PaymentViewController: UIViewController {

    @IBOutlet weak var payDeptBtn: UIButton!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var addBtn: UIButton!
    
    
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
