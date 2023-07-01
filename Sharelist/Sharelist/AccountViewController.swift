//
//  AccountViewController.swift
//  Sharelist
//
//  Created by Melina Osterloh on 21.06.23.
//

import UIKit
import Firebase
import Toast


class AccountViewController: UIViewController {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var logoutBtn: UIButton!
    
    var selectedListUID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
           let selectedListID = appDelegate.selectedListID {
        }
        
        if let user = Auth.auth().currentUser {
            let email = user.email
            emailLabel.text = email
        } else {
            emailLabel.text = "Benutzer ist nicht eingeloggt"
        }
        
        
        
      
        
    }
    
    @IBAction func logoutButton(_ sender: UIButton) {
        
        let auth = Auth.auth()
        
        do {
            try auth.signOut()
        } catch {
            print("User Logout failed!")
        }
        self.performSegue(withIdentifier: "goToLoginScreen", sender: self)
    }
    

    

}
