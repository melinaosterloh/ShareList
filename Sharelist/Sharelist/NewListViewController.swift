//
//  NewListViewController.swift
//  Sharelist
//
//  Created by Melina Osterloh on 28.06.23.
//

import UIKit
import Firebase
import Toast

class NewListViewController: UIViewController {


    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var listName: UITextField!
    @IBOutlet weak var createListBtn: UIButton!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var inviteBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDesign()

    }

    @IBAction func closeBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func checkButton(_ sender: UIButton) {
        dismiss(animated: true)
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
        

    }
    
    
}
