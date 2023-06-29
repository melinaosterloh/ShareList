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
    
    
    

    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var addListBtn: UIButton!
    
    
    //var listArray = [Article]()
    //var article: Article?
    //private var document: [DocumentSnapshot] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addListBtn.layer.cornerRadius = addListBtn.bounds.height / 2
        addListBtn.layer.shadowOpacity = 0.5
        addListBtn.layer.shadowColor = UIColor.darkGray.cgColor
        addListBtn.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        closeBtn.layer.cornerRadius = closeBtn.bounds.height / 2
        closeBtn.layer.shadowRadius = 2
        closeBtn.layer.shadowOpacity = 0.5
        closeBtn.layer.shadowColor = UIColor.darkGray.cgColor
        closeBtn.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        overlayView.layer.shadowRadius = 5
        overlayView.layer.shadowOpacity = 0.5
        overlayView.layer.shadowColor = UIColor.darkGray.cgColor
        overlayView.layer.shadowOffset = CGSize(width: 1, height: 1)

        if let user = Auth.auth().currentUser {
            let email = user.email
            emailLabel.text = email
        } else {
            emailLabel.text = "Benutzer ist nicht eingeloggt"
        }


    }
    

    
    @IBAction func logoutButton(_ sender: UIButton) {
        let mainViewController = storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        mainViewController.modalPresentationStyle = .overCurrentContext
        mainViewController.modalTransitionStyle = .crossDissolve
        present(mainViewController, animated: true, completion: nil)
        
        let auth = Auth.auth()
        
        do {
            try auth.signOut()
        } catch {
            print("User Logout failed!")
        }
        self.performSegue(withIdentifier: "goToLoginScreen", sender: self)
    }
    
    @IBAction func closeButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func addListButton(_ sender: UIButton) {
        let newListViewController = storyboard?.instantiateViewController(withIdentifier: "NewListViewController") as! NewListViewController
        newListViewController.modalPresentationStyle = .overCurrentContext
        newListViewController.modalTransitionStyle = .crossDissolve
        present(newListViewController, animated: true, completion: nil)
    }
    
    


}
