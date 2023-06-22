//
//  MainViewController.swift
//  Sharelist
//
//  Created by Melina Osterloh on 18.06.23.
//

import UIKit
import Firebase
import Toast

class MainViewController: UIViewController {

    @IBOutlet var blurView: UIVisualEffectView!
    @IBOutlet var loginPopUpView: UIView!
    
    @IBOutlet weak var emailLogin: UITextField!
    @IBOutlet weak var passwordLogin: UITextField!
    
    @IBOutlet weak var popUpLoginBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registrationBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()


        emailLogin.layer.borderColor = UIColor.darkGray.cgColor
        emailLogin.layer.borderWidth = 1
        emailLogin.layer.cornerRadius = 5
        
        passwordLogin.layer.borderColor = UIColor.darkGray.cgColor
        passwordLogin.layer.borderWidth = 1
        passwordLogin.layer.cornerRadius = 5
        
        loginBtn.layer.cornerRadius = 10
        loginBtn.layer.shadowRadius = 2
        loginBtn.layer.shadowOpacity = 0.5
        loginBtn.layer.shadowColor = UIColor.darkGray.cgColor
        loginBtn.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        registrationBtn.layer.cornerRadius = 10
        registrationBtn.layer.shadowRadius = 2
        registrationBtn.layer.shadowOpacity = 0.5
        registrationBtn.layer.shadowColor = UIColor.darkGray.cgColor
        registrationBtn.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        popUpLoginBtn.layer.cornerRadius = 10
        popUpLoginBtn.layer.shadowRadius = 2
        popUpLoginBtn.layer.shadowOpacity = 0.5
        popUpLoginBtn.layer.shadowColor = UIColor.darkGray.cgColor
        popUpLoginBtn.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        
        // blurView Größe ist gleich der Größe von der gesamten View
        blurView.bounds = self.view.bounds
        
        // width = 90%, height = 40%
        loginPopUpView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.8, height: self.view.bounds.height * 0.3)
        loginPopUpView.layer.cornerRadius = 20
        
        
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        animateIn(loginView: blurView)
        animateIn(loginView: loginPopUpView)
    }
    
    @IBAction func popUpLoginButton(_ sender: UIButton) {
        guard let email = emailLogin.text else { return }
        guard let password = passwordLogin.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { firebaseResult, error in
            if let error = error  {
                self.view.makeToast("E-Mail und/oder Passwort stimmen nicht!", duration: 2.0)
                print("Error at Login")
            }
            else {
                //Go to home screen
                self.performSegue(withIdentifier: "goToListView", sender: self)
                
            }
        }
        //animateOut(loginView: blurView)
        //animateOut(loginView: loginPopUpView)
        //self.performSegue(withIdentifier: "goToListView", sender: self)
    }
    
    
    func animateIn(loginView: UIView) {
        let backgroundView = self.view!
        
        // fügt subview zum Screen hinzu
        backgroundView.addSubview(loginView)
        
        // setzt view Skalierung auf 120%
        loginView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        loginView.alpha = 0
        loginView.center = backgroundView.center
        
        // Animationseffekt
        UIView.animate(withDuration: 0.3, animations: {
            loginView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            loginView.alpha = 1
        })
    }
    
    func animateOut(loginView: UIView) {
        UIView.animate(withDuration: 0.3, animations: {
            loginView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            loginView.alpha = 0
        }, completion: { (success:Bool) in
            loginView.removeFromSuperview()
        })
    }
    

}
